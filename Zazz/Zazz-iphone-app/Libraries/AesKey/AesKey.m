#import "AesKey.h"



@interface AesKey () {

    SecKeyRef _entry;
    NSMutableDictionary *_attributes;
}

@property (nonatomic, readonly) SecKeyRef keyRef;


/** Retrieve key's data. */
- (NSData *)_encode;

/** Insert this key into keystore. */
- (void)_insertData:(NSData *)data;

/** Query key within keystore. */
- (void)_queryKeyWithInfo:(NSDictionary *)info;

@end


@implementation AesKey


@synthesize blocksize=_blocksize, keysize=_keysize;


#pragma mark - Class's constructors
- (id)init {
    self = [super init];
    if (self) {
        _identifier = @"com.key.aes";
        _entry      = NULL;
        _keysize    = 0;
        _blocksize  = 0;

        // Initialize attributes dictionary
        _attributes = [[NSMutableDictionary alloc] initWithCapacity:23];
        
        // Identify secret key
        [_attributes setObject:(id)kSecClassKey forKey:(id)kSecClass];
        [_attributes setObject:[_identifier dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecAttrApplicationTag];
        [_attributes setObject:[NSNumber numberWithUnsignedInteger:(_keysize << 3)] forKey:(id)kSecAttrKeySizeInBits];
        [_attributes setObject:[NSNumber numberWithUnsignedInteger:(_keysize << 3)] forKey:(id)kSecAttrEffectiveKeySize];

        // Indentify key's attributes
        [_attributes setObject:(id)[NSNumber numberWithUnsignedInt:2147483649] forKey:(id)kSecAttrType];
        [_attributes setObject:(id)kCFBooleanFalse forKey:(id)kSecAttrCreator];
        [_attributes setObject:(id)kCFBooleanTrue  forKey:(id)kSecAttrCanDecrypt];
        [_attributes setObject:(id)kCFBooleanFalse forKey:(id)kSecAttrCanDerive];
        [_attributes setObject:(id)kCFBooleanTrue  forKey:(id)kSecAttrCanEncrypt];
        [_attributes setObject:(id)kCFBooleanFalse forKey:(id)kSecAttrKeyClass];
        [_attributes setObject:(id)kCFBooleanTrue  forKey:(id)kSecAttrIsPermanent];
        [_attributes setObject:(id)kCFBooleanFalse forKey:(id)kSecAttrCanSign];
        [_attributes setObject:(id)kCFBooleanFalse forKey:(id)kSecAttrCanUnwrap];
        [_attributes setObject:(id)kCFBooleanFalse forKey:(id)kSecAttrCanVerify];
        [_attributes setObject:(id)kCFBooleanFalse forKey:(id)kSecAttrCanWrap];
    }
    return self;
}


#pragma mark - Cleanup memory
- (void)dealloc {
    FwiRelease(_identifier);
    FwiRelease(_attributes);
    FwiReleaseCF(_entry);

#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}


#pragma mark - Class's properties
- (SecKeyRef)keyRef {
    /* Condition validation */
    if (![self inKeystore]) return NULL;

    NSDictionary *query = @{(id)kSecValuePersistentRef:(id)_entry, (id)kSecReturnRef:(id)kCFBooleanTrue};
    SecKeyRef key = nil;

    SecItemCopyMatching((CFDictionaryRef)query, (CFTypeRef *)&key);
    return key;
}
- (size_t)keysize {
    return _keysize;
}
- (size_t)blocksize {
    return ([self inKeystore] ? kCCBlockSizeAES128 : 0);
}

- (void)setIdentifier:(NSString *)identifier {
    /* Condition validation */
    if (!identifier || identifier.length == 0) return;

    NSData *data = nil;
    if ([self inKeystore]) {
        // 1. Backup current key's data
        data = [self _encode];

        // 2. Remove key from keystore
        [self remove];
    }

    // 3. Update key's identifier
    FwiRelease(_identifier);
    _identifier = [identifier retain];
    [_attributes setObject:[_identifier dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecAttrApplicationTag];

    // 4. Insert into keystore again
    if (data && data.length > 0) {
        [self _insertData:data];
    }
}


#pragma mark - Class's public methods
- (NSData *)decryptData:(NSData *)data, ... NS_REQUIRES_NIL_TERMINATION {
    /* Condition validation */
    if (![self inKeystore]) {
        DLog(@"[INFO] '%@' key was not inserted into keystore or had been removed from keystore, skip this step...", self.identifier);
        return nil;
    }

    /* Condition validation: Do not need to decrypt if there is no encrypted data */
    if (!data) return nil;

    // Append all data together
    NSMutableData *encryptedData = [[NSMutableData alloc] initWithData:data];
	va_list args;
	va_start(args, data);
	while ((data = va_arg(args, id))) {
        if ([data isKindOfClass:[NSData class]]) [encryptedData appendData:data];
	}
	va_end(args);

    /* Condition validation: Do not need to decrypt if there is no encrypted data */
	if (encryptedData.length <= 0) {
        FwiRelease(encryptedData);
        return nil;
    }

    // Perform decrypt
    size_t lengthEst = encryptedData.length;    // Estimate output length
    size_t lengthAct = 0;                       // Actual output length

    uint8_t *output  = malloc(lengthEst);
    NSData  *keyData = [self _encode];
    CCCryptorStatus status = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                     keyData.bytes, keyData.length, NULL,
                                     encryptedData.bytes, encryptedData.length,
                                     output, lengthEst, &lengthAct);
    [keyData clearBytes];

    // Clean up
    FwiRelease(encryptedData);
    __autoreleasing NSData *rawData = nil;

    // Prepare output data
    if (status == kCCSuccess) rawData = FwiAutoRelease([[NSData alloc] initWithBytes:output length:lengthAct]);
    else rawData = FwiAutoRelease([[NSData alloc] init]);

    free(output);
	return rawData;
}
- (NSData *)encryptData:(NSData *)data, ... NS_REQUIRES_NIL_TERMINATION {
    /* Condition validation */
    if (![self inKeystore]) {
        DLog(@"[INFO] '%@' key was not inserted into keystore or had been removed from keystore, skip this step...", self.identifier);
        return nil;
    }

    /* Condition validation: Do not need to encrypt if there is no data */
    if (!data) return nil;

    // Append all data together
    NSMutableData *rawData = [[NSMutableData alloc] initWithData:data];
	va_list args;
	va_start(args, data);
	while ((data = va_arg(args, id))) {
        if ([data isKindOfClass:[NSData class]]) [rawData appendData:data];
	}
	va_end(args);

    /* Condition validation: Do not need to encrypt if there is no data */
	if (rawData.length <= 0) {
        FwiRelease(rawData);
        return nil;
    }

    // Perform encrypt
    size_t lengthEst = rawData.length + self.blocksize;     // Estimate output length
    size_t lengthAct = 0;                                   // Actual output length

    uint8_t *output  = malloc(lengthEst);
    NSData  *keyData = [self _encode];
    CCCryptorStatus status = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                     keyData.bytes, keyData.length, NULL,
                                     rawData.bytes, rawData.length,
                                     output, lengthEst, &lengthAct);
    [keyData clearBytes];

    // Clean up
    FwiRelease(rawData);
    __autoreleasing NSData *encryptedData = nil;

    // Prepare output data
    if (status == kCCSuccess) encryptedData = FwiAutoRelease([[NSData alloc] initWithBytes:output length:lengthAct]);
    else encryptedData = FwiAutoRelease([[NSData alloc] init]);
    
    free(output);
	return encryptedData;
}

- (BOOL)inKeystore {
    return (_entry != nil);
}
- (void)remove {
    /* Condition validation */
    if (![self inKeystore]) {
        DLog(@"[INFO] '%@' key was not inserted into keystore or had been removed from keystore, skip this step...", _identifier);
        return;
    }

    NSDictionary *keyInfo = @{(id)kSecValuePersistentRef:(id)_entry};
    OSStatus status = SecItemDelete((CFDictionaryRef)keyInfo);

    if (status == errSecSuccess) {
        DLog(@"[INFO] '%@' key had been removed from keystore...", _identifier);

        // Remove all keys that have similar identifier but different size
        keyInfo = @{(id)kSecClass:(id)kSecClassKey, (id)kSecAttrApplicationTag:[_identifier dataUsingEncoding:NSUTF8StringEncoding]};
        do {
            status = SecItemDelete((CFDictionaryRef)keyInfo);
        }
        while (status == errSecSuccess);

        // Release this entry
        FwiReleaseCF(_entry);
        FwiRelease(_attributes);

        // Initialize attributes dictionary
        _attributes = [[NSMutableDictionary alloc] initWithCapacity:15];

        // Identify secret key
        [_attributes setObject:(id)kSecClassKey forKey:(id)kSecClass];
        [_attributes setObject:[_identifier dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecAttrApplicationTag];
        [_attributes setObject:[NSNumber numberWithUnsignedInteger:(_keysize << 3)] forKey:(id)kSecAttrKeySizeInBits];
        [_attributes setObject:[NSNumber numberWithUnsignedInteger:(_keysize << 3)] forKey:(id)kSecAttrEffectiveKeySize];

        // Indentify key's attributes
        [_attributes setObject:(id)[NSNumber numberWithUnsignedInt:2147483649] forKey:(id)kSecAttrType];
        [_attributes setObject:(id)kCFBooleanFalse forKey:(id)kSecAttrCreator];
        [_attributes setObject:(id)kCFBooleanTrue  forKey:(id)kSecAttrCanDecrypt];
        [_attributes setObject:(id)kCFBooleanFalse forKey:(id)kSecAttrCanDerive];
        [_attributes setObject:(id)kCFBooleanTrue  forKey:(id)kSecAttrCanEncrypt];
        [_attributes setObject:(id)kCFBooleanFalse forKey:(id)kSecAttrKeyClass];
        [_attributes setObject:(id)kCFBooleanTrue  forKey:(id)kSecAttrIsPermanent];
        [_attributes setObject:(id)kCFBooleanFalse forKey:(id)kSecAttrCanSign];
        [_attributes setObject:(id)kCFBooleanFalse forKey:(id)kSecAttrCanUnwrap];
        [_attributes setObject:(id)kCFBooleanFalse forKey:(id)kSecAttrCanVerify];
        [_attributes setObject:(id)kCFBooleanFalse forKey:(id)kSecAttrCanWrap];
    }
    else {
        DLog(@"[ERROR] Could not remove '%@' key from keystore!", _identifier);
    }
}


#pragma mark - Class's private methods
- (NSData *)_encode {
    /* Condition validation */
    if (![self inKeystore]) return nil;

    NSData *data = nil;
    CFDataRef dataRef = nil;
    NSDictionary *keyInfo = @{(id)kSecValuePersistentRef:(id)_entry, (id)kSecReturnData:(id)kCFBooleanTrue};

    OSStatus status = SecItemCopyMatching((CFDictionaryRef)keyInfo, (CFTypeRef *)&dataRef);
    if (status == errSecSuccess) {
        data = (NSData *)dataRef;
        [data autorelease];
    }
    else {
        FwiReleaseCF(dataRef);
    }
    return data;
}

- (void)_insertData:(NSData *)data {
    /* Condition validation: Remove old key data from keystore */
    if (_entry) [self remove];

    // Update keysize
    _keysize = data.length;

    // Update attributes
    _attributes[(id)kSecAttrKeySizeInBits]    = [NSNumber numberWithUnsignedInteger:(_keysize << 3)];
    _attributes[(id)kSecAttrEffectiveKeySize] = [NSNumber numberWithUnsignedInteger:(_keysize << 3)];
    _attributes[(id)kSecValueData]            = data;
    _attributes[(id)kSecReturnPersistentRef]  = (id)kCFBooleanTrue;

    OSStatus status = SecItemAdd((CFDictionaryRef)_attributes, (CFTypeRef *)&_entry);
    if (status == errSecSuccess) {
        [data clearBytes];
        DLog(@"[INFO] Success insert '%@' key into keystore...", _identifier);
    }
    else {
        DLog(@"[ERROR] Could not insert '%@' key into keystore!", _identifier);
    }
}
- (void)_queryKeyWithInfo:(NSDictionary *)info {
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)info, (CFTypeRef *)&_entry);

    if (status == errSecSuccess) {
        NSDictionary *attrQuery = @{(id)kSecValuePersistentRef:(id)_entry, (id)kSecReturnAttributes:(id)kCFBooleanTrue};
        CFDictionaryRef attrRef = nil;

        status = SecItemCopyMatching((CFDictionaryRef)attrQuery, (CFTypeRef *)&attrRef);

        if (status == errSecSuccess) {
            // Update key attributes
            [((NSDictionary *) attrRef) enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
                _attributes[key] = value;
            }];
            if (_attributes[@"v_Data"]) [_attributes removeObjectForKey:@"v_Data"];
            if (_attributes[@"r_PersistentRef"]) [_attributes removeObjectForKey:@"r_PersistentRef"];

            // Update key size
            _keysize = [(NSNumber *)[_attributes objectForKey:(id)kSecAttrKeySizeInBits] unsignedIntegerValue] >> 3;
        }
        FwiReleaseCF(attrRef);
    }
}


@end


@implementation AesKey (FwiKeyCreation)


#pragma mark - Class's static constructors
+ (AesKey *)keystoreWithIdentifier:(NSString *)identifier {
    return [[[AesKey alloc] initWithIdentifier:identifier] autorelease];
}
+ (AesKey *)keystoreWithIdentifier:(NSString *)identifier data:(NSData *)data {
    return [[[AesKey alloc] initWithIdentifier:identifier data:data] autorelease];
}


#pragma mark - Class's constructors
- (id)initWithIdentifier:(NSString *)identifier {
    self = [self init];
    if (self) {
        self.identifier = identifier;

        // Update key attribute
        [self _queryKeyWithInfo:@{(id)kSecClass:[_attributes objectForKey:(id)kSecClass],
                                  (id)kSecAttrApplicationTag:[_identifier dataUsingEncoding:NSUTF8StringEncoding],
                                  (id)kSecReturnPersistentRef:(id)kCFBooleanTrue}];
    }
    return self;
}
- (id)initWithIdentifier:(NSString *)identifier data:(NSData *)data {
    self = [self initWithIdentifier:identifier];
    if (self) {
        // 1. Insert key data
        [self _insertData:data];

        // 2. Update key attribute
        [self _queryKeyWithInfo:@{(id)kSecClass:[_attributes objectForKey:(id)kSecClass],
                                  (id)kSecAttrApplicationTag:[_identifier dataUsingEncoding:NSUTF8StringEncoding],
                                  (id)kSecReturnPersistentRef:(id)kCFBooleanTrue}];
    }
    return self;
}


@end