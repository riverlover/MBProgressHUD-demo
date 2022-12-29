//
//  NSString+Utils.m
//  MBProgressHUD-demo
//
//  Created by 李真河 on 2022/12/29.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)
+ (NSString*)timeStapStringTranfer2:(NSString *)timestamp{
    long long time=[timestamp longLongValue];
    //如果服务器返回的是13位字符串，需要除以1000，否则显示不正确(13位其实代表的是毫秒，需要除以1000)
    if (timestamp.length>10) {
        time=[timestamp doubleValue] / 1000.0;
    }

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString   = [formatter stringFromDate: date];
    return  dateString;
}
// 得到当前本地时间，13位，整形
+ (long long)gs_getCurrentTimeToMilliSecond {

    double currentTime = [[NSDate date] timeIntervalSince1970] * 1000;

    long long iTime = (long long)currentTime;

    return iTime;

}
@end

