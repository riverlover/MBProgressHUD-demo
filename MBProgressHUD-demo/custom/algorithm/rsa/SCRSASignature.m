//
//  SCRSASignature.m
//  MBProgressHUD-demo
//
//  Created by 李真河 on 2022/12/29.
//

#import "SCRSASignature.h"
#import "RSA.h"
//导入头文件：#import <CommonCrypto/CommonDigest.h>  否则无法使用 ：CC_SHA256_DIGEST_LENGTH
#import <CommonCrypto/CommonDigest.h>

@implementation SCRSASignature

// 签名
+ (NSString *) sign:(NSString *)storString{
    NSLog(@"签名前：%@",storString);
   // 使用哈希算法获取字符串摘要
//   NSLog(@"=0===== [%@]",storString);
   // sha256加密
   NSData *outData = [self sha256:storString];

  //使用私钥字符串获取SecKeyRef指针，通过读取pem文件即可获取，网上代码很多。也可使用指数、模数生成，参考此库https://github.com/ideawu/Objective-C-RSA。
   SecKeyRef pKey = [RSA addPrivateKey:[self getPrivateKey]];      //app的私钥
   size_t siglen = SecKeyGetBlockSize(pKey);
   uint8_t* signedHashBytes = malloc(siglen);
   memset(signedHashBytes, 0x0, siglen);
   SecKeyRawSign(pKey,
                 kSecPaddingPKCS1SHA256,
                 outData.bytes,
                 outData.length,
                 signedHashBytes,
                 &siglen);
   NSData* signedHash = [NSData dataWithBytes:signedHashBytes length:(NSUInteger)siglen];
   NSString *signString = [signedHash base64EncodedStringWithOptions:NSUTF8StringEncoding];
//   NSLog(@"=1===== %@",signString);
   if (!signString) {
       return @"";
   }
   return signString;
}

// 签名  也可使用指数、模数生成
//+ (NSString *) sign:(NSString *)storString{
//
//    // 使用哈希算法获取字符串摘要
//    NSData *outData = [self sha256:storString];
//    // 私钥key
//    SecKeyRef privateKey = [RSA addPrivateKey:[self getPrivateKey]];
//
//    // sha256WithRSA加密
//    size_t signedHashBytesSize = SecKeyGetBlockSize(privateKey);
//    uint8_t* signedHashBytes = malloc(signedHashBytesSize);
//    memset(signedHashBytes, 0x0, signedHashBytesSize);
//
//    size_t hashBytesSize = CC_SHA256_DIGEST_LENGTH;
//    uint8_t* hashBytes = malloc(hashBytesSize);
//    if (!CC_SHA256([outData bytes], (CC_LONG)[outData length], hashBytes)) {
//        return nil;
//    }
//    SecKeyRawSign(privateKey,
//                  kSecPaddingPKCS1SHA256,
//                  hashBytes,
//                  hashBytesSize,
//                  signedHashBytes,
//                  &signedHashBytesSize);
//
//    NSData* signedHash = [NSData dataWithBytes:signedHashBytes length:(NSUInteger)signedHashBytesSize];
//
//    if (hashBytes)
//        free(hashBytes);
//    if (signedHashBytes)
//        free(signedHashBytes);
//
//    NSString *signString = [signedHash base64EncodedStringWithOptions:NSUTF8StringEncoding];
////    NSString *encodedString = [RSA encoding:signString];
//    return signString;
//}


//使用私钥字符串获取SecKeyRef指针，通过读取pem文件即可获取
//+ (NSString *) sign:(NSString *)storString{
//    NSLog(@"%@",storString);
//    HBRSAHandler* handler = [HBRSAHandler new];
//    [handler importKeyWithType:KeyTypePrivate andkeyString:[self getPrivateKey]];
//    [handler importKeyWithType:KeyTypePublic andkeyString:[self getServicePublicKey]];
//
//    NSString* sig = [handler signString:storString];
//
//    BOOL a = [handler verifyString:storString withSign:sig];
//    if (a) {
//        NSLog(@"验签成功");
//    }else{
//        NSLog(@"验签失败");
//    }
//
//    return sig;
//}

//验签
+(BOOL) verifySign:(NSString *)response signString:(NSString *)signString{
   // sha256加密
   NSData *outData = [self sha256:response];
   // 签名base64解码
   NSData *signData = [[NSData alloc] initWithBase64EncodedString:signString options:NSDataBase64DecodingIgnoreUnknownCharacters];
   // 签名验证
   SecKeyRef pKey = [RSA addPrivateKey:[self getServicePublicKey]];  //服务器的公钥获取
   size_t siglen = SecKeyGetBlockSize(pKey);
   const void* signedHashBytes = [signData bytes];
   OSStatus status = SecKeyRawVerify(pKey,
                                     kSecPaddingPKCS1SHA256,
                                     outData.bytes,
                                     outData.length,
                                     signedHashBytes,
                                     siglen);

   return status == errSecSuccess;
   
}


#pragma mark: --使用哈希算法获取待签名字符串的摘要
+ (NSData *) sha256:(NSString *)str {
   const char *s = [str cStringUsingEncoding:NSUTF8StringEncoding];
   NSData *strData = [NSData dataWithBytes:s length:strlen(s)];
   uint8_t digest [CC_SHA256_DIGEST_LENGTH] = {0};
   CC_SHA256(strData.bytes, (CC_LONG)strData.length, digest);
   NSData *data = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
   return data;
}



#pragma mark: --parkcode      签名和验证签名: 签名是由发送数据的一方发起的，防止传输过程中被篡改数据内容。因此签名使用的是私钥。而验证签名使用的是公钥。
+(NSString*)getPrivateKey{
    return @"MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCpP8XBzxAlPYSlMdQ33jqN4zsPr1e9amTzECDxqbtxaRRgarwGF61mhxp1eo3xBUZZNEHL2M8/Lf1AypsjJ+NhSLQyUOq2GE97XYQqR1IOaOXTPdW3vjI2rE7RX4wTFZ+H4IDDYq+8bs8LsoremkUUv1jJM+ItQf0qP8bEfag2G5+htQlVABS2/OVvtZWSeX4IUIeo3YamQcUFWByEk0B237WwbZUZtt4SiEpkDFXkirtev52QREh/ap3OdmQ+iL04OaWqsiboxeQDQ7xLWw/SH4Twzi2gJSsOpzlHQQ+sD9g/SnJ9dIjliPyMZB9K7YaRdwdFPuaMogmAqMb16k1nAgMBAAECggEAJlGv/n9ZEnVpMNWlTLjd3P4TgyuZ2+LY1EdUjiJ1s+msmV/RDjgSJGJ2VR7YQDeHg+7W7sY5tf49lovIsB751i7VzYaQfYXniPDVWZUoOOb7EeawGpfPWp2Mgs71MeT1Z5gmzxXq3+jeq7FSy6918IqaGYPLs597KDOkVxx0Fzuuc8BnVeOHiYh9hVGOdKCs6hvFFBtN4PWRuRqC7CyeLlJTd/I4QE4uf3tl4mSMCaoKNOcoa4NnR6CvkwEQQqYVhnJoA8dxBwiYEVbDmM6vrFJgo2hBV0xcMNUvvVqg1pkZjuxuBXmDkcakpTTCKaCUUWEPk0Wa2w6B5783/cb8UQKBgQDzPyVzVO6p3S9ZZJCqSwy9MBJw/8TQvmR4DRpSE/kLiuYs7rJIzjFhyWp4rFHrp2AdkAP9EznjVBFc8FlqI27b4lmEDFDe5Ep06rq3D+ESYjXrqKxFLp6UCGvM+orRjtaYT1GaAUQUBkTKzOG58IJRLI+s3hyDw/pgrhCFXzmz0wKBgQCyH26UVsRFmbmMxX4WIdzfBh+rEq2jgm0k9zO/xALkTK+x6u/qkKElO5eIZWOxqaboxddhpDU86uRcX89rkQliIx5NnFGrsnfKtd5Ew+iJ9nNUg9jPtdpPcDX2EqHG+nFRvfka+tWVj8LKIRFvJXB0VXSsWU/CUcrxR+VQB4rHnQKBgDT+fuQ/jreHLrelBzdynlXhUUM5FeH8eNsGz8MuAsYW/sqvPjxKX8vUG9QqhrZ2gqQuKhBKzgPO3vGGk5RiH9bb23C/VicZSXdrZD5ZwUlGCEVNPCreW0IZC5NeyjuZiPsp3LdWq0RJkVc1h8AAvAN/V9Xrlf7HBZdmlMbZ1jJtAoGBAIZbQzPNRvsg+1790R+sp0fq/JQz4JoHVYCenoA1v+CpH5XamuGZ+pN1IdYWdF6ck3PdV5slG6s5mss60eBXZHaL+t2b3dbfJZDYIjJIe+0k4tWLJk125JcrEujsIO9QFY4M+AurzNOlvs5spxPpb6uwkfM24vy2aZgaHRSCu+HZAoGBANlpYD+TEHtGgEGSO4F6iJlCaJCQ9sg0eiRhntgYmj2rK2cuOQMpdjY1b224yw/bEPb99Z4RwhzlbbTuIBQkQIjnhCgcThrCS2xQaaeQ8l790JOGuhIXkRT1leIWHTiJIkPDtaGPnEEDoWEe3pbs1q+3yK5E/KNsfMJVdUh4Vc6m";
}

+(NSString*)getServicePublicKey{
    return @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqT/Fwc8QJT2EpTHUN946jeM7D69XvWpk8xAg8am7cWkUYGq8BhetZocadXqN8QVGWTRBy9jPPy39QMqbIyfjYUi0MlDqthhPe12EKkdSDmjl0z3Vt74yNqxO0V+MExWfh+CAw2KvvG7PC7KK3ppFFL9YyTPiLUH9Kj/GxH2oNhufobUJVQAUtvzlb7WVknl+CFCHqN2GpkHFBVgchJNAdt+1sG2VGbbeEohKZAxV5Iq7Xr+dkERIf2qdznZkPoi9ODmlqrIm6MXkA0O8S1sP0h+E8M4toCUrDqc5R0EPrA/YP0pyfXSI5Yj8jGQfSu2GkXcHRT7mjKIJgKjG9epNZwIDAQAB";
}
@end
