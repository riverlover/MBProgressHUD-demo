//
//  SZHttpRequest.m
//  MBProgressHUD-demo
//
//  Created by 李真河 on 2022/12/29.
//

#import "SZHttpRequest.h"
#import "SZNetRequestModel.h"
#import "SZSingleHttpSession.h"
#import "NSDictionary+JKJSONString.h"

@implementation SZHttpRequest

+(void)requestDataWithParam:(NSMutableDictionary *)param businessId:(NSString *)businessId  responseDict:(resposeBlock)responseDict{
    
    [[self alloc]requestDataWithParam:param  businessId:businessId  responseDictit:responseDict];
}

-(void)requestDataWithParam:(NSMutableDictionary *)param  businessId:(NSString *)businessId  responseDictit:(resposeBlock)responseDict{
    __block  NSMutableDictionary *returnDict = [NSMutableDictionary dictionary];
    
     SZNetRequestModel *requestModel=[[SZNetRequestModel alloc]initWithMethod:businessId andRequestDic:param];
      NSString *str=[requestModel mainUrlJoiningMethodStr] ;
    NSLog(@"全地址：%@",str);
    //设置登录 Session-Id 值 请求头

    NSString *sessionId = [[NSUserDefaults standardUserDefaults] valueForKey:SessionId];
    
    AFHTTPSessionManager *manager = [SZSingleHttpSession shareManager];
    
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    requestSerializer.timeoutInterval = 20.0;
   
    //token 设置请求头
    [requestSerializer setValue:sessionId forHTTPHeaderField:@"Session-Id"];
    
    //设置允许 @"application/json", @"text/json", @"text/javascript",@"text/html",
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [requestSerializer setValue:@"text/html" forHTTPHeaderField:@"Accept"];
    
    
    
    manager.requestSerializer = requestSerializer ;
   
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil ,nil];
    NSLog(@"请求头：%@",sessionId);
    
    [manager POST:[requestModel mainUrlJoiningMethodStr] parameters:[requestModel getDictionary] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"%@",[responseObject jk_JSONString]);
         NSString *retCode =[NSString stringWithFormat:@"%@",responseObject[sign_code]];
         if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *codeSTr;
             if ([retCode isEqualToString:sign_succes_code]) {
                 //NSLog(@"%@",responseObject[sign_data][DATA]);
                          codeSTr=[NSString stringWithFormat:@"%d",[responseObject[sign_data][CODE] intValue]];
                 if ([codeSTr isEqualToString:SessionTimeOutCode]) {
//                     [[SZSingleClass shareManager] deleteSelf];
//                     [[NSNotificationCenter defaultCenter] postNotificationName:LoginStatusTimeOutNotiName object:nil];
                 }
                          [returnDict setValue:codeSTr forKey:@"code"];
                          [returnDict setValue:responseObject[sign_data][MESSAGE] forKey:@"msg"];
                          [returnDict setValue:responseObject[sign_data][DATA] forKey:DATA];
                 
             }else{
                 codeSTr = [NSString stringWithFormat:@"%@",responseObject[sign_code]];
                   
                 [returnDict setValue:codeSTr forKey:@"code"];
                 [returnDict setValue:responseObject[@"ret_msg"] forKey:@"msg"];
                 [returnDict setValue:@[] forKey:@"data"];
                 NSLog(@"请求非200 == error == %@",responseObject[@"ret_msg"]);
                
             }
         }
         
        responseDict(returnDict,YES);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [returnDict setValue:@"fail" forKey:@"code"];
        [returnDict setValue:error.userInfo[@"NSLocalizedDescription"] forKey:@"msg"];
        [returnDict setValue:@[] forKey:@"data"];
        NSLog(@"上传错误 == error == %@",error);
        responseDict(returnDict,NO);
    }];
}
@end
