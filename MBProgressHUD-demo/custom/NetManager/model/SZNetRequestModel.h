//
//  SZNetRequestModel.h
//  MBProgressHUD-demo
//
//  Created by 李真河 on 2022/12/29.
//
#define Main_URL @"https://app.jzcstc.com/gateway.do"
#define app_id  @"d2a57dc1d883fd21fb9951699df71cc7"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SZNetRequestModel : NSObject
@property(nonatomic,copy)NSString *appID;//"2020032799776956"
@property(nonatomic,copy)NSString *signType;// "RSA2"
@property(nonatomic,copy)NSString *version;//"2.0"
@property(nonatomic,copy)NSString *charset;//"utf-8"
@property(nonatomic,copy)NSString *timestamp;//"20190819182614"
@property(nonatomic,copy)NSString *format ;//json
@property (nonatomic,copy)NSString * sign;//RSA 签名(deviceId,requestId,method,value)
@property (nonatomic,copy) NSString * token;//登录token验证
@property (nonatomic,copy) NSString * deviceId;//设备编号
@property (nonatomic,copy) NSString * method;//请求方式 主地址需要拼接的模块数据后缀
@property(nonatomic,strong)NSMutableDictionary *requestDic;
@property(nonatomic,strong)NSDictionary *paramsDic;

// 创建一个model
-(id)initWithMethod:(NSString*)method andRequestDic:(NSDictionary*)requestDic;

//根据model创建一个dic
- (NSDictionary *)getDictionary;

//根据model 拼接请求地址
-(NSString*)mainUrlJoiningMethodStr;
@end

NS_ASSUME_NONNULL_END
