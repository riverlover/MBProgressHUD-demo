//
//  NSString+Utils.h
//  MBProgressHUD-demo
//
//  Created by 李真河 on 2022/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Utils)
+(NSString*)timeStapStringTranfer2:(NSString *)timestamp;
// 得到当前本地时间，13位，整形
+ (long long)gs_getCurrentTimeToMilliSecond;
@end

NS_ASSUME_NONNULL_END
