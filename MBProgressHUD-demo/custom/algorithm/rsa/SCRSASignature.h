//
//  SCRSASignature.h
//  MBProgressHUD-demo
//
//  Created by 李真河 on 2022/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCRSASignature : NSObject

// 签名  : json 字符串             然后 字典key 顺序排序一下  拼接转成 key=value&  字符串格式
+ (NSString *) sign:(NSString *)storString;
//验签
+(BOOL) verifySign:(NSString *)response signString:(NSString *)signString;
@end

NS_ASSUME_NONNULL_END
