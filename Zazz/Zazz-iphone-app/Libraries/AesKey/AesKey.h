#import <Foundation/Foundation.h>


@interface AesKey : NSObject {
}

@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, readonly) size_t blocksize;
@property (nonatomic, readonly) size_t keysize;


- (NSData *)decryptData:(NSData *)data, ... NS_REQUIRES_NIL_TERMINATION;
- (NSData *)encryptData:(NSData *)data, ... NS_REQUIRES_NIL_TERMINATION;

- (BOOL)inKeystore;
- (void)remove;

@end


@interface AesKey (FwkAESKeyCreation)

// Class's static constructors
+ (AesKey *)keystoreWithIdentifier:(NSString *)identifier;
+ (AesKey *)keystoreWithIdentifier:(NSString *)identifier data:(NSData *)data;

// Class's constructors
- (id)initWithIdentifier:(NSString *)identifier;
- (id)initWithIdentifier:(NSString *)identifier data:(NSData *)data;

@end