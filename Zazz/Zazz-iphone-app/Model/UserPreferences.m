#import "UserPreferences.h"
#import "UserServices.h"
#import "AesKey.h"


@interface UserPreferences () <FwiOperationDelegate> {

    AesKey *_key;
    NSMutableDictionary *_preferences;
}

@property (nonatomic, retain) UserServices *userServices;

@end


@implementation UserPreferences


#pragma mark - Class's constructors
- (id)init {
    self = [super init];
    if (self) {
        // Initialize AES Key
        _key = [AesKey keystoreWithIdentifier:@"__zazz.aes.key"];
        if (![_key inKeystore]) {
            NSString *randomData = [[NSString randomIdentifier] stringByReplacingOccurrencesOfString:@"-" withString:@""];
            _key = [AesKey keystoreWithIdentifier:@"__zazz.aes.key" data:[randomData toData]];
        }

        // Initialize preferences
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [userDefaults objectForKey:@"_preferences"];
        if (!data || data.length == 0) {
            _preferences = [[NSMutableDictionary alloc] initWithCapacity:10];
        }
        else {
            // Decrypted data
            NSData *decryptedData = [_key decryptData:data, nil];
            
            @try {
                NSDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:decryptedData];
                _preferences = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
            }
            @catch (NSException *exception) {
                _preferences = [[NSMutableDictionary alloc] initWithCapacity:10];
            }
        }

        // Load user's profile & Continue upload
        if ([self accessToken].length > 0) {
            UserServices *upload = [[UserServices alloc] init];
            upload.delegate = self;
            [upload execute];

            self.userServices = upload;
            FwiRelease(upload);
        }
    }
    return self;
}


#pragma mark - Cleanup memory
- (void)dealloc {
    FwiRelease(_key);
    FwiRelease(_preferences);

    if (self.userServices) {
        [self.userServices cancel];
        self.userServices = nil;
    }

#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}


#pragma mark - Class's properties


#pragma mark - Class's public methods
- (id)valueForKey:(NSString *)key {
    return _preferences[key];
}
- (void)setValue:(id)value key:(NSString *)key {
    /* Condition validation */
    if (!key || key.length == 0) return;

    @synchronized (_preferences) {
        if (value) [_preferences setValue:value forKey:key];
        else [_preferences removeObjectForKey:key];
    }
}

- (void)reset {
    if (self.userServices) {
        [self.userServices cancel];
        self.userServices = nil;
    }
    
    [self setCurrentUsername:nil];
    [self setCurrentProfileId:nil];
    [self setTokenType:nil];
    [self setExpiredTime:nil];
    [self setAccessToken:nil];
    [self setRefreshToken:nil];
    [self save];
}

- (void)save {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_preferences];
    
    // Encrypted data
    NSData *encryptedData = [_key encryptData:data, nil];

    // Save encrypted data
    [userDefaults setObject:encryptedData forKey:@"_preferences"];
    [userDefaults synchronize];
}


#pragma mark - Class's private methods


#pragma mark - FwiOperationDelegate's members
- (void)operation:(FwiOperation *)operation didFinishWithStage:(FwiOPState)stage userInfo:(NSDictionary *)userInfo {
    DLog(@"Operation did finish: %@", NSStringFromClass([operation class]));
}


@end


@implementation UserPreferences (UserCredentials)


- (NSString *)clientId {
    return @"";
}

- (NSString *)clientSecret {
    return @"";
}

- (NSString *)currentUsername {
    return [self valueForKey:@"_currentUsername"];
}
- (void)setCurrentUsername:(NSString *)currentUsername {
    [self setValue:currentUsername key:@"_currentUsername"];
}

- (NSString *)currentProfileId {
    return [self valueForKey:@"_currentProfileId"];
}
- (void)setCurrentProfileId:(NSString *)currentProfileId {
    [self setValue:currentProfileId key:@"_currentProfileId"];
}

- (NSString *)tokenType {
    return [self valueForKey:@"_tokenType"];
}
- (void)setTokenType:(NSString *)tokenType {
    [self setValue:tokenType key:@"_tokenType"];
}

- (NSDate *)expiredTime {
    return [self valueForKey:@"_expiredTime"];
}
- (void)setExpiredTime:(NSDate *)expiredTime {
    [self setValue:expiredTime key:@"_expiredTime"];
}

- (NSString *)accessToken {
    return [self valueForKey:@"_accessToken"];
}
- (void)setAccessToken:(NSString *)accessToken {
    if (!accessToken || accessToken.length == 0) {
        [_preferences removeObjectForKey:@"_accessToken"];
    }
    else {
        [self setValue:accessToken key:@"_accessToken"];
        
        // Begin upload cron jobs
        if (!self.userServices) {
            UserServices *upload = [[UserServices alloc] init];
            upload.delegate = self;
            [upload execute];
            
            self.userServices = upload;
            FwiRelease(upload);
        }
    }
}

- (NSString *)refreshToken {
    return [self valueForKey:@"_refreshToken"];
}
- (void)setRefreshToken:(NSString *)refreshToken {
    [self setValue:refreshToken key:@"_refreshToken"];
}


@end