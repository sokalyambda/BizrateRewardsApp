//
//  OB_KeyChainStore.h
//  OB_KeyChainStore
//


#import <Foundation/Foundation.h>

extern NSString * const OB_KeyChainStoreErrorDomain;

typedef NS_ENUM(NSInteger, OB_KeyChainStoreErrorCode) {
    OB_KeyChainStoreErrorInvalidArguments = 1,
};

typedef NS_ENUM(NSInteger, OB_KeyChainStoreItemClass) {
    OB_KeyChainStoreItemClassGenericPassword = 1,
    OB_KeyChainStoreItemClassInternetPassword,
};

typedef NS_ENUM(NSInteger, OB_KeyChainStoreProtocolType) {
    OB_KeyChainStoreProtocolTypeFTP = 1,
    OB_KeyChainStoreProtocolTypeFTPAccount,
    OB_KeyChainStoreProtocolTypeHTTP,
    OB_KeyChainStoreProtocolTypeIRC,
    OB_KeyChainStoreProtocolTypeNNTP,
    OB_KeyChainStoreProtocolTypePOP3,
    OB_KeyChainStoreProtocolTypeSMTP,
    OB_KeyChainStoreProtocolTypeSOCKS,
    OB_KeyChainStoreProtocolTypeIMAP,
    OB_KeyChainStoreProtocolTypeLDAP,
    OB_KeyChainStoreProtocolTypeAppleTalk,
    OB_KeyChainStoreProtocolTypeAFP,
    OB_KeyChainStoreProtocolTypeTelnet,
    OB_KeyChainStoreProtocolTypeSSH,
    OB_KeyChainStoreProtocolTypeFTPS,
    OB_KeyChainStoreProtocolTypeHTTPS,
    OB_KeyChainStoreProtocolTypeHTTPProxy,
    OB_KeyChainStoreProtocolTypeHTTPSProxy,
    OB_KeyChainStoreProtocolTypeFTPProxy,
    OB_KeyChainStoreProtocolTypeSMB,
    OB_KeyChainStoreProtocolTypeRTSP,
    OB_KeyChainStoreProtocolTypeRTSPProxy,
    OB_KeyChainStoreProtocolTypeDAAP,
    OB_KeyChainStoreProtocolTypeEPPC,
    OB_KeyChainStoreProtocolTypeNNTPS,
    OB_KeyChainStoreProtocolTypeLDAPS,
    OB_KeyChainStoreProtocolTypeTelnetS,
    OB_KeyChainStoreProtocolTypeIRCS,
    OB_KeyChainStoreProtocolTypePOP3S,
};

typedef NS_ENUM(NSInteger, OB_KeyChainStoreAuthenticationType) {
    OB_KeyChainStoreAuthenticationTypeNTLM = 1,
    OB_KeyChainStoreAuthenticationTypeMSN,
    OB_KeyChainStoreAuthenticationTypeDPA,
    OB_KeyChainStoreAuthenticationTypeRPA,
    OB_KeyChainStoreAuthenticationTypeHTTPBasic,
    OB_KeyChainStoreAuthenticationTypeHTTPDigest,
    OB_KeyChainStoreAuthenticationTypeHTMLForm,
    OB_KeyChainStoreAuthenticationTypeDefault,
};

typedef NS_ENUM(NSInteger, OB_KeyChainStoreAccessibility) {
    OB_KeyChainStoreAccessibilityWhenUnlocked = 1,
    OB_KeyChainStoreAccessibilityAfterFirstUnlock,
    OB_KeyChainStoreAccessibilityAlways,
    OB_KeyChainStoreAccessibilityWhenPasscodeSetThisDeviceOnly
    __OSX_AVAILABLE_STARTING(__MAC_10_10, __IPHONE_8_0),
    OB_KeyChainStoreAccessibilityWhenUnlockedThisDeviceOnly,
    OB_KeyChainStoreAccessibilityAfterFirstUnlockThisDeviceOnly,
    OB_KeyChainStoreAccessibilityAlwaysThisDeviceOnly,
}
__OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_4_0);

typedef NS_ENUM(NSInteger, OB_KeyChainStoreAuthenticationPolicy) {
    OB_KeyChainStoreAuthenticationPolicyUserPresence = kSecAccessControlUserPresence,
};

@interface OB_KeyChainStore : NSObject

@property (nonatomic, readonly) OB_KeyChainStoreItemClass itemClass;

@property (nonatomic, readonly) NSString *service;
@property (nonatomic, readonly) NSString *accessGroup;

@property (nonatomic, readonly) NSURL *server;
@property (nonatomic, readonly) OB_KeyChainStoreProtocolType protocolType;
@property (nonatomic, readonly) OB_KeyChainStoreAuthenticationType authenticationType;

@property (nonatomic) OB_KeyChainStoreAccessibility accessibility;
@property (nonatomic, readonly) OB_KeyChainStoreAuthenticationPolicy authenticationPolicy
__OSX_AVAILABLE_STARTING(__MAC_10_10, __IPHONE_8_0);

@property (nonatomic) BOOL synchronizable;

@property (nonatomic) NSString *authenticationPrompt
__OSX_AVAILABLE_STARTING(__MAC_NA, __IPHONE_8_0);

@property (nonatomic, readonly) NSArray *allKeys;
@property (nonatomic, readonly) NSArray *allItems;

+ (NSString *)defaultService;
+ (void)setDefaultService:(NSString *)defaultService;

+ (OB_KeyChainStore *)keyChainStore;
+ (OB_KeyChainStore *)keyChainStoreWithService:(NSString *)service;
+ (OB_KeyChainStore *)keyChainStoreWithService:(NSString *)service accessGroup:(NSString *)accessGroup;

+ (OB_KeyChainStore *)keyChainStoreWithServer:(NSURL *)server protocolType:(OB_KeyChainStoreProtocolType)protocolType;
+ (OB_KeyChainStore *)keyChainStoreWithServer:(NSURL *)server protocolType:(OB_KeyChainStoreProtocolType)protocolType authenticationType:(OB_KeyChainStoreAuthenticationType)authenticationType;

- (instancetype)init;
- (instancetype)initWithService:(NSString *)service;
- (instancetype)initWithService:(NSString *)service accessGroup:(NSString *)accessGroup;

- (instancetype)initWithServer:(NSURL *)server protocolType:(OB_KeyChainStoreProtocolType)protocolType;
- (instancetype)initWithServer:(NSURL *)server protocolType:(OB_KeyChainStoreProtocolType)protocolType authenticationType:(OB_KeyChainStoreAuthenticationType)authenticationType;

+ (NSString *)stringForKey:(NSString *)key;
+ (NSString *)stringForKey:(NSString *)key service:(NSString *)service;
+ (NSString *)stringForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup;
+ (BOOL)setString:(NSString *)value forKey:(NSString *)key;
+ (BOOL)setString:(NSString *)value forKey:(NSString *)key service:(NSString *)service;
+ (BOOL)setString:(NSString *)value forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup;

+ (NSData *)dataForKey:(NSString *)key;
+ (NSData *)dataForKey:(NSString *)key service:(NSString *)service;
+ (NSData *)dataForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup;
+ (BOOL)setData:(NSData *)data forKey:(NSString *)key;
+ (BOOL)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service;
+ (BOOL)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup;

- (BOOL)contains:(NSString *)key;

- (BOOL)setString:(NSString *)string forKey:(NSString *)key;
- (BOOL)setString:(NSString *)string forKey:(NSString *)key label:(NSString *)label comment:(NSString *)comment;
- (NSString *)stringForKey:(NSString *)key;

- (BOOL)setData:(NSData *)data forKey:(NSString *)key;
- (BOOL)setData:(NSData *)data forKey:(NSString *)key label:(NSString *)label comment:(NSString *)comment;
- (NSData *)dataForKey:(NSString *)key;

+ (BOOL)removeItemForKey:(NSString *)key;
+ (BOOL)removeItemForKey:(NSString *)key service:(NSString *)service;
+ (BOOL)removeItemForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup;

+ (BOOL)removeAllItems;
+ (BOOL)removeAllItemsForService:(NSString *)service;
+ (BOOL)removeAllItemsForService:(NSString *)service accessGroup:(NSString *)accessGroup;

- (BOOL)removeItemForKey:(NSString *)key;

- (BOOL)removeAllItems;

- (NSString *)objectForKeyedSubscript:(NSString <NSCopying> *)key;
- (void)setObject:(NSString *)obj forKeyedSubscript:(NSString <NSCopying> *)key;

+ (NSArray *)allKeysWithItemClass:(OB_KeyChainStoreItemClass)itemClass;
- (NSArray *)allKeys;

+ (NSArray *)allItemsWithItemClass:(OB_KeyChainStoreItemClass)itemClass;
- (NSArray *)allItems;

- (void)setAccessibility:(OB_KeyChainStoreAccessibility)accessibility authenticationPolicy:(OB_KeyChainStoreAuthenticationPolicy)authenticationPolicy
__OSX_AVAILABLE_STARTING(__MAC_10_10, __IPHONE_8_0);

#if TARGET_OS_IPHONE
- (void)sharedPasswordWithCompletion:(void (^)(NSString *account, NSString *password, NSError *error))completion;
- (void)sharedPasswordForAccount:(NSString *)account completion:(void (^)(NSString *password, NSError *error))completion;

- (void)setSharedPassword:(NSString *)password forAccount:(NSString *)account completion:(void (^)(NSError *error))completion;
- (void)removeSharedPasswordForAccount:(NSString *)account completion:(void (^)(NSError *error))completion;

+ (void)requestSharedWebCredentialWithCompletion:(void (^)(NSArray *credentials, NSError *error))completion;
+ (void)requestSharedWebCredentialForDomain:(NSString *)domain account:(NSString *)account completion:(void (^)(NSArray *credentials, NSError *error))completion;

+ (NSString *)generatePassword;
#endif

@end

@interface OB_KeyChainStore (ErrorHandling)

+ (NSString *)stringForKey:(NSString *)key error:(NSError * __autoreleasing *)error;
+ (NSString *)stringForKey:(NSString *)key service:(NSString *)service error:(NSError * __autoreleasing *)error;
+ (NSString *)stringForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup error:(NSError * __autoreleasing *)error;

+ (BOOL)setString:(NSString *)value forKey:(NSString *)key error:(NSError * __autoreleasing *)error;
+ (BOOL)setString:(NSString *)value forKey:(NSString *)key service:(NSString *)service error:(NSError * __autoreleasing *)error;
+ (BOOL)setString:(NSString *)value forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup error:(NSError * __autoreleasing *)error;

+ (NSData *)dataForKey:(NSString *)key error:(NSError * __autoreleasing *)error;
+ (NSData *)dataForKey:(NSString *)key service:(NSString *)service error:(NSError * __autoreleasing *)error;
+ (NSData *)dataForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup error:(NSError * __autoreleasing *)error;

+ (BOOL)setData:(NSData *)data forKey:(NSString *)key error:(NSError * __autoreleasing *)error;
+ (BOOL)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service error:(NSError * __autoreleasing *)error;
+ (BOOL)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup error:(NSError * __autoreleasing *)error;

- (BOOL)setString:(NSString *)string forKey:(NSString *)key error:(NSError * __autoreleasing *)error;
- (BOOL)setString:(NSString *)string forKey:(NSString *)key label:(NSString *)label comment:(NSString *)comment error:(NSError * __autoreleasing *)error;

- (BOOL)setData:(NSData *)data forKey:(NSString *)key error:(NSError * __autoreleasing *)error;
- (BOOL)setData:(NSData *)data forKey:(NSString *)key label:(NSString *)label comment:(NSString *)comment error:(NSError * __autoreleasing *)error;

- (NSString *)stringForKey:(NSString *)key error:(NSError * __autoreleasing *)error;
- (NSData *)dataForKey:(NSString *)key error:(NSError * __autoreleasing *)error;

+ (BOOL)removeItemForKey:(NSString *)key error:(NSError * __autoreleasing *)error;
+ (BOOL)removeItemForKey:(NSString *)key service:(NSString *)service error:(NSError * __autoreleasing *)error;
+ (BOOL)removeItemForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup error:(NSError * __autoreleasing *)error;

+ (BOOL)removeAllItemsWithError:(NSError * __autoreleasing *)error;
+ (BOOL)removeAllItemsForService:(NSString *)service error:(NSError * __autoreleasing *)error;
+ (BOOL)removeAllItemsForService:(NSString *)service accessGroup:(NSString *)accessGroup error:(NSError * __autoreleasing *)error;

- (BOOL)removeItemForKey:(NSString *)key error:(NSError * __autoreleasing *)error;
- (BOOL)removeAllItemsWithError:(NSError * __autoreleasing *)error;

@end

@interface OB_KeyChainStore (ForwardCompatibility)

+ (BOOL)setString:(NSString *)value forKey:(NSString *)key genericAttribute:(id)genericAttribute;
+ (BOOL)setString:(NSString *)value forKey:(NSString *)key genericAttribute:(id)genericAttribute error:(NSError * __autoreleasing *)error;

+ (BOOL)setString:(NSString *)value forKey:(NSString *)key service:(NSString *)service genericAttribute:(id)genericAttribute;
+ (BOOL)setString:(NSString *)value forKey:(NSString *)key service:(NSString *)service genericAttribute:(id)genericAttribute error:(NSError * __autoreleasing *)error;

+ (BOOL)setString:(NSString *)value forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup genericAttribute:(id)genericAttribute;
+ (BOOL)setString:(NSString *)value forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup genericAttribute:(id)genericAttribute error:(NSError * __autoreleasing *)error;

+ (BOOL)setData:(NSData *)data forKey:(NSString *)key genericAttribute:(id)genericAttribute;
+ (BOOL)setData:(NSData *)data forKey:(NSString *)key genericAttribute:(id)genericAttribute error:(NSError * __autoreleasing *)error;

+ (BOOL)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service genericAttribute:(id)genericAttribute;
+ (BOOL)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service genericAttribute:(id)genericAttribute error:(NSError * __autoreleasing *)error;

+ (BOOL)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup genericAttribute:(id)genericAttribute;
+ (BOOL)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup genericAttribute:(id)genericAttribute error:(NSError * __autoreleasing *)error;

- (BOOL)setString:(NSString *)string forKey:(NSString *)key genericAttribute:(id)genericAttribute;
- (BOOL)setString:(NSString *)string forKey:(NSString *)key genericAttribute:(id)genericAttribute error:(NSError * __autoreleasing *)error;

- (BOOL)setData:(NSData *)data forKey:(NSString *)key genericAttribute:(id)genericAttribute;
- (BOOL)setData:(NSData *)data forKey:(NSString *)key genericAttribute:(id)genericAttribute error:(NSError * __autoreleasing *)error;

@end

@interface OB_KeyChainStore (Deprecation)

- (void)synchronize __attribute__((deprecated("calling this method is no longer required")));
- (BOOL)synchronizeWithError:(NSError *__autoreleasing *)error __attribute__((deprecated("calling this method is no longer required")));

@end
