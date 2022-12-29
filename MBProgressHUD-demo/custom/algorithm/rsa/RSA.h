//
//  RSA.h
//  MBProgressHUD-demo
//
//  Created by 李真河 on 2022/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RSA : NSObject

/**
 * 加密方法
 *
 * @param str 需要加密的字符串
 * @param pubKey 公钥字符串
 */
// return base64 encoded string
+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey;
// return base64 encoded string
+ (NSString *)encryptString:(NSString *)str privateKey:(NSString *)privKey;

// decrypt base64 encoded string, convert result to string(not base64 encoded)
+ (NSString *)decryptString:(NSString *)str publicKey:(NSString *)pubKey;
/**
 * 解密方法
 *
 * @param str 需要解密的字符串
 * @param privKey 私钥字符串
 */
+ (NSString *)decryptString:(NSString *)str privateKey:(NSString *)privKey;

// return raw data
+ (NSData *)encryptData:(NSData *)data publicKey:(NSString *)pubKey;
// return raw data
+ (NSData *)encryptData:(NSData *)data privateKey:(NSString *)privKey;

+ (NSData *)decryptData:(NSData *)data publicKey:(NSString *)pubKey;
+ (NSData *)decryptData:(NSData *)data privateKey:(NSString *)privKey;

+ (NSString*)encoding:(NSString*)signString;

//使用私钥字符串获取SecKeyRef指针，通过读取pem文件即可获取，网上代码很多。也可使用指数、模数生成，参考此库。
+ (SecKeyRef)addPublicKey:(NSString *)key;
+ (SecKeyRef)addPrivateKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
