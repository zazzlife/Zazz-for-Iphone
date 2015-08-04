#import <Foundation/Foundation.h>


@interface UserPreferences : NSObject {
}


/** Load/Save object value. */
- (id)objectForKey:(NSString *)key;
- (void)setValue:(id)value key:(NSString *)key;

/** Reset user's preferences */
- (void)reset;
/** Save user's preferences. */
- (void)save;

@end


@interface UserPreferences (UserCredentials)

/** Load/Save token type. */
- (NSString *)clientId;

/** Load/Save secret key. */
- (NSString *)clientSecret;

/** Load/Save current username. */
- (NSString *)currentUsername;
- (void)setCurrentUsername:(NSString *)currentUsername;

/** Load/Save user's profileId. */
- (NSString *)currentProfileId;
- (void)setCurrentProfileId:(NSString *)currentProfileId;

/** Load/Save token type. */
- (NSString *)tokenType;
- (void)setTokenType:(NSString *)tokenType;

/** Load/Save token type. */
- (NSDate *)expiredTime;
- (void)setExpiredTime:(NSDate *)expiredTime;

/** Load/Save access token. */
- (NSString *)accessToken;
- (void)setAccessToken:(NSString *)accessToken;

/** Load/Save refresh token. */
- (NSString *)refreshToken;
- (void)setRefreshToken:(NSString *)refreshToken;

@end