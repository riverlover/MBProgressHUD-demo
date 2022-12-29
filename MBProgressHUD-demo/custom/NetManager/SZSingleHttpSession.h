//
//  SZSingleHttpSession.h
//  MBProgressHUD-demo
//
//  Created by 李真河 on 2022/12/29.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface SZSingleHttpSession : NSObject
//单例
+(AFHTTPSessionManager *)shareManager;
@end

NS_ASSUME_NONNULL_END
