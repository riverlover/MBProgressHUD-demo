//
//  SZSingleHttpSession.m
//  MBProgressHUD-demo
//
//  Created by 李真河 on 2022/12/29.
//

#import "SZSingleHttpSession.h"

@implementation SZSingleHttpSession

static AFHTTPSessionManager *manager;

+(AFHTTPSessionManager *)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
//        manager.responseSerializer =  [AFHTTPResponseSerializer serializer];
//        manager.requestSerializer.timeoutInterval = 20.0;
    });
    return manager;
}
@end
