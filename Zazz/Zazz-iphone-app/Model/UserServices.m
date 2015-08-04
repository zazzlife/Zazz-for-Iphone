#import "UserServices.h"


@interface UserServices () {

    NSTimer *_timer;
}

@property (atomic, assign, getter = isRefresh) BOOL refresh;


/** Refresh access token. */
- (void)_doRefreshAccessToken;

@end


@implementation UserServices


#pragma mark - Class's constructors
- (id)init {
    self = [super init];
    if (self) {
        self.longOperation = YES;
    }
    return self;
}


#pragma mark - Cleanup memory
- (void)dealloc {
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}


#pragma mark - Class's properties


#pragma mark - Class's public methods
- (void)executeBusiness {
    /* Condition validation */
    if (self.isCancelled) return;
    
    // Create timer to keep the cron job alive
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(_doServices) userInfo:nil repeats:YES];
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    [runloop run];
}


#pragma mark - Class's private methods
- (void)_doServices {
    @synchronized (self) {
        if (self.isCancelled) {
            [_timer invalidate];
            _timer = nil;
            return;
        }
    }
    
    [self _doRefreshAccessToken];
}

- (void)_doRefreshAccessToken {
//    __block NSDate *now = [NSDate date];
//    __block NSDate *expiredTime = [kUserPreferences expiredTime];
//    
//    /* Condition validation: Validate the expired time */
//    if ((expiredTime.timeIntervalSince1970 - now.timeIntervalSince1970) >= 180.0f) return;
//    
//    /* Condition validation: Validate the refresh status */
//    if (self.isRefresh) return;
//    self.refresh = YES;
//    
//    
//    FwiJson *request = [FwiJson object:
//                        @"grant_type"   , [FwiJson stringWithString:@"refresh_token"],
//                        @"refresh_token", [FwiJson stringWithString:[kUserPreferences refreshToken]],
//                        @"client_id"    , [FwiJson stringWithString:[kUserPreferences clientId]],
//                        @"client_secret", [FwiJson stringWithString:[kUserPreferences clientSecret]],
//                        nil];
//    
//    [kNetworkManager sendBackgroundRequest:request
//                                    toURL:generateURL(kService_Authorization)
//                                   method:kMethodType_Post
//                               completion:^(FwiJson *responseMessage, NSError *error, FwiNetworkStatus statusCode) {
//                                   if (200 <= statusCode && statusCode <= 299) {
//                                       FwiJson *validation = [FwiJson object:
//                                                              @"access_token", [FwiJson string],
//                                                              @"expires_in", [FwiJson number],
//                                                              @"token_type", [FwiJson string],
//                                                              @"scope", [FwiJson null],
//                                                              nil];
//                                       
//                                       if ([responseMessage isLike:validation]) {
//                                           // Persist authorization code
//                                           [kUserPreferences setTokenType:[[responseMessage jsonWithPath:@"token_type"] getString]];
//                                           [kUserPreferences setAccessToken:[[responseMessage jsonWithPath:@"access_token"] getString]];
//                                           [kUserPreferences setRefreshToken:[[responseMessage jsonWithPath:@"refresh_token"] getString]];
//                                           
//                                           // Expire time
//                                           now = [NSDate date];
//                                           expiredTime = [NSDate dateWithTimeInterval:[[[responseMessage jsonWithPath:@"expires_in"] getNumber] doubleValue] sinceDate:now];
//                                           
//                                           // Save
//                                           [kUserPreferences setExpiredTime:expiredTime];
//                                           [kUserPreferences save];
//                                       }
//                                   }
//                                   else {
//                                       dispatch_async(dispatch_get_main_queue(), ^{
//                                           [kAppDelegate presentAlertWithTitle:kText_Info message:@"Your session is expired. Please re-login."];
//                                           [kUserPreferences reset];
//                                           [kAppController presentAuthenticationFlow];
//                                       });
//                                   }
//                                   self.refresh = NO;
//                               }];
}


@end