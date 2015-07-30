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
        _key = [AesKey keystoreWithIdentifier:@"__iwitness.aes.key"];
        if (![_key inKeystore]) {
            NSString *randomData = [[NSString randomIdentifier] stringByReplacingOccurrencesOfString:@"-" withString:@""];
            _key = [AesKey keystoreWithIdentifier:@"__iwitness.aes.key" data:[randomData toData]];
        }
        [_key retain];

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
- (id)objectForKey:(NSString *)key {
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
    
    [self setEventId:nil];
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
    return @"1ef28784-23f8-11e4-b8aa-000c29c9a052";
}

- (NSString *)clientSecret {
    return @"26b30aba-23f8-11e4-b8aa-000c29c9a052";
}

- (NSString *)currentUsername {
    return [self objectForKey:@"_currentUsername"];
}
- (void)setCurrentUsername:(NSString *)currentUsername {
    if (!currentUsername || currentUsername.length == 0) {
        [_preferences removeObjectForKey:@"_currentUsername"];
    }
    else {
        [self setValue:currentUsername key:@"_currentUsername"];
    }
}

- (NSString *)currentProfileId {
    return [self objectForKey:@"_currentProfileId"];
}
- (void)setCurrentProfileId:(NSString *)currentProfileId {
    if (!currentProfileId || currentProfileId.length == 0) {
        [_preferences removeObjectForKey:@"_currentProfileId"];
    }
    else {
        [self setValue:currentProfileId key:@"_currentProfileId"];
    }
}

- (NSString *)tokenType {
    return [self objectForKey:@"_tokenType"];
}
- (void)setTokenType:(NSString *)tokenType {
    if (!tokenType || tokenType.length == 0) {
        [_preferences removeObjectForKey:@"_tokenType"];
    }
    else {
        [self setValue:tokenType key:@"_tokenType"];
    }
}

- (NSDate *)expiredTime {
    return [self objectForKey:@"_expiredTime"];
}
- (void)setExpiredTime:(NSDate *)expiredTime {
    if (!expiredTime) {
        [_preferences removeObjectForKey:@"_expiredTime"];
    }
    else {
        [self setValue:expiredTime key:@"_expiredTime"];
    }
}

- (NSString *)accessToken {
    return [self objectForKey:@"_accessToken"];
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
    return [self objectForKey:@"_refreshToken"];
}
- (void)setRefreshToken:(NSString *)refreshToken {
    if (!refreshToken || refreshToken.length == 0) {
        [_preferences removeObjectForKey:@"_refreshToken"];
    }
    else {
        [self setValue:refreshToken key:@"_refreshToken"];
    }
}


@end


@implementation UserPreferences (UserProfile)


- (BOOL)isFirstLogin {
    NSNumber *isFirstLogin = [self objectForKey:[NSString stringWithFormat:@"%@/_isFirstLogin", [self currentProfileId]]];
    return (isFirstLogin ? [isFirstLogin boolValue] : YES);
}
- (void)setFirstLogin:(BOOL)isFirstLogin {
    [self setValue:[NSNumber numberWithBool:isFirstLogin] key:[NSString stringWithFormat:@"%@/_isFirstLogin", [self currentProfileId]]];
}

- (BOOL)isFirstRegistered {
    NSNumber *isFirstRegistered = [self objectForKey:[NSString stringWithFormat:@"%@/_isFirstRegistered", [self currentProfileId]]];
    return (isFirstRegistered ? [isFirstRegistered boolValue] : NO);
}

- (void)setFirstRegistered:(BOOL)isFirstRegistered {
    [self setValue:[NSNumber numberWithBool:isFirstRegistered] key:[NSString stringWithFormat:@"%@/_isFirstRegistered", [self currentProfileId]]];
}

- (NSString *)eventId {
    return [self objectForKey:[NSString stringWithFormat:@"%@/_eventId", [self currentProfileId]]];
}
- (void)setEventId:(NSString *)eventId {
    if (!eventId || eventId.length == 0) {
        [_preferences removeObjectForKey:[NSString stringWithFormat:@"%@/_eventId", [self currentProfileId]]];
    }
    else {
        [self setValue:eventId key:[NSString stringWithFormat:@"%@/_eventId", [self currentProfileId]]];
    }
}


@end


@implementation UserPreferences (UserSettings)


- (BOOL)enableShake {
    NSNumber *enableShake = [self objectForKey:[NSString stringWithFormat:@"%@/_enableShake", [self currentProfileId]]];
    return (enableShake ? [enableShake boolValue] : YES);
}
- (void)setEnableShake:(BOOL)enableShake {
    /* Condition validation */
    if (![self currentProfileId] || [self currentProfileId].length == 0) return;
    [self setValue:[NSNumber numberWithBool:enableShake] key:[NSString stringWithFormat:@"%@/_enableShake", [self currentProfileId]]];
}

- (BOOL)enableTorch {
    NSNumber *enableTorch = [self objectForKey:[NSString stringWithFormat:@"%@/_enableTorch", [self currentProfileId]]];
    return (enableTorch ? [enableTorch boolValue] : YES);
}
- (void)setEnableTorch:(BOOL)enableTorch {
    /* Condition validation */
    if (![self currentProfileId] || [self currentProfileId].length == 0) return;
    [self setValue:[NSNumber numberWithBool:enableTorch] key:[NSString stringWithFormat:@"%@/_enableTorch", [self currentProfileId]]];
}

- (NSString *)emergencyPhone {
    NSString *emergencyPhone = [self objectForKey:[NSString stringWithFormat:@"%@/_emergencyPhone", [self currentProfileId]]];
    return (emergencyPhone ? emergencyPhone : @"United States of America");
}
- (void)setEmergencyPhone:(NSString *)emergencyPhone {
    /* Condition validation */
    if (![self currentProfileId] || [self currentProfileId].length == 0) return;
    [self setValue:emergencyPhone key:[NSString stringWithFormat:@"%@/_emergencyPhone", [self currentProfileId]]];
}


- (NSInteger)recordTime {
    NSNumber *recordTime = [self objectForKey:[NSString stringWithFormat:@"%@/_recordTime", [self currentProfileId]]];
    return (recordTime ? [recordTime integerValue] : 300);
}
- (void)setRecordTime:(NSInteger)recordTime {
    /* Condition validation */
    if (![self currentProfileId] || [self currentProfileId].length == 0) return;
    [self setValue:[NSNumber numberWithInteger:recordTime] key:[NSString stringWithFormat:@"%@/_recordTime", [self currentProfileId]]];
}


@end