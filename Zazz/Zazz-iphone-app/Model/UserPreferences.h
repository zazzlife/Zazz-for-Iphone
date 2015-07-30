//  Project name: Zazz-iphone-app
//  File name   : UserPreferences.h
//
//  Author      : Phuc, Tran Huu
//  Created date: 4/28/14
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright (C) 2014 WebOnyx. All rights reserved.
//  --------------------------------------------------------------

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


@interface UserPreferences (UserProfile)

/** Load/Save first login stage. */
- (BOOL)isFirstLogin;
- (void)setFirstLogin:(BOOL)isFirstLogin;

/** Load/Save first register stage. */
- (BOOL)isFirstRegistered;
- (void)setFirstRegistered:(BOOL)isFirstRegistered;

/** Load/Save event's Id. */
- (NSString *)eventId;
- (void)setEventId:(NSString *)eventId;

@end


@interface UserPreferences (UserSettings)

/** Load/Save on/off */
- (BOOL)enableShake;
- (void)setEnableShake:(BOOL)enableShake;

/** Load/Save on/off torch. */
- (BOOL)enableTorch;
- (void)setEnableTorch:(BOOL)enableTorch;

/** Load/Save emergency phone number. */
- (NSString *)emergencyPhone;
- (void)setEmergencyPhone:(NSString *)emergencyPhone;

/** Load/Save recording time for an event. */
- (NSInteger)recordTime;
- (void)setRecordTime:(NSInteger)recordTime;

@end