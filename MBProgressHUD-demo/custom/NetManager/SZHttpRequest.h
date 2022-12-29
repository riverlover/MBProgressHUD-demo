//
//  SZHttpRequest.h
//  MBProgressHUD-demo
//
//  Created by 李真河 on 2022/12/29.
//
#define SessionId @"sessionId"
#define sign_code @"ret_code"
#define sign_msg @"ret_msg"
#define sign_data @"content"
#define sign_succes_code @"200"

#define DATA @"data"
#define MESSAGE @"msg"
#define CODE @"code"
#define success_code @"200"

//登录超时
#define SessionTimeOutCode @"4"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^resposeBlock)(NSDictionary *responseObject,BOOL responseOK);

@interface SZHttpRequest : NSObject
// 基本请求 传参数
+(void)requestDataWithParam:(NSMutableDictionary *)param businessId:(NSString *)businessId  responseDict:(resposeBlock)responseDict;



@end

NS_ASSUME_NONNULL_END
