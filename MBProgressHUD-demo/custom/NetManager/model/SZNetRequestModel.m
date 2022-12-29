//
//  SZNetRequestModel.m
//  MBProgressHUD-demo
//
//  Created by 李真河 on 2022/12/29.
//

#import "SZNetRequestModel.h"
#import "NSString+Utils.h"
#import "SCRSASignature.h"

@implementation SZNetRequestModel

-(id)initWithMethod:(NSString *)method andRequestDic:(NSDictionary *)requestDic{
    self=[super init];
    if (self) {
        //设置登录 token 值
//        NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
//        self.token=token;
        
//        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
//        NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
//        self.version = currentVersion;
//        self.system=@"IPHONE";
        //设置手机编号
//        self.deviceId = [UIDevice currentDevice].identifierForVendor.UUIDString;
        
        NSString *time = [NSString stringWithFormat:@"%lld",[NSString gs_getCurrentTimeToMilliSecond]];
        NSLog(@"当前时间戳：%@",time);
        NSLog(@"%@",[NSString timeStapStringTranfer2:time]);
        self.timestamp = [NSString timeStapStringTranfer2:time];
        
        self.method=method;
        
        
        self.paramsDic = requestDic;
        self.requestDic=[NSMutableDictionary dictionaryWithDictionary:requestDic];
    }
    return self;
}

-(NSDictionary*)getDictionary{
    
    [self.requestDic setValue:app_id forKey:@"app_id"];
    [self.requestDic setValue:@"RSA2" forKey:@"sign_type"];
    [self.requestDic setValue:@"2.0" forKey:@"version"];
    [self.requestDic setValue:@"utf-8" forKey:@"charset"];
    [self.requestDic setValue:self.timestamp forKey:@"timestamp"];
    [self.requestDic setValue:@"json" forKey:@"format"];
    [self.requestDic setValue:self.method forKey:@"method"];
    
    //设置 RSA 签名(deviceId,requestId,method,value)
    NSString *signString = [SCRSASignature sign:[self signStr]];
    self.sign = signString;
  

    
    [self.requestDic setValue:self.sign forKey:@"sign"];
//    NSLog(@"%@",self.requestDic);
 

    return self.requestDic;
    
}

-(NSString*)mainUrlJoiningMethodStr{
    NSString *url=[NSString stringWithFormat:@"%@",Main_URL];
//    NSString *url=[NSString stringWithFormat:@"%@%@",Main_URL,self.method];
    
    return url;
}

-(NSString*)signStr{
    NSString *str = @"";
    NSLog(@"准备遍历%@",self.requestDic);
    NSArray *keysArr = (NSArray*)[self.requestDic allKeys];
    
    //1.先顺序排序
    keysArr = [keysArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    
    //拼接 key=value&  字符串格式
//    NSLog(@"准备遍历%@",keysArr);
    int index = 0 ;
    for (int i=0;i<keysArr.count;i++) {
        NSLog(@"%@",keysArr[i]);
        if (index==0) {
            str = [NSString stringWithFormat:@"%@=%@",keysArr[i],[self.requestDic objectForKey:keysArr[i]]];
        }else{
            str = [NSString stringWithFormat:@"%@&%@=%@",str,keysArr[i],[self.requestDic objectForKey:keysArr[i]]];
        }
        index = index +1 ;
       
    }
    NSLog(@"遍历%@",str);
    return str;
}

#pragma mark: --parkcode      签名和验证签名: 签名是由发送数据的一方发起的，防止传输过程中被篡改数据内容。因此签名使用的是私钥。而验证签名使用的是公钥。
-(NSString*)getPrivateKey{
    return @"MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCpP8XBzxAlPYSlMdQ33jqN4zsPr1e9amTzECDxqbtxaRRgarwGF61mhxp1eo3xBUZZNEHL2M8/Lf1AypsjJ+NhSLQyUOq2GE97XYQqR1IOaOXTPdW3vjI2rE7RX4wTFZ+H4IDDYq+8bs8LsoremkUUv1jJM+ItQf0qP8bEfag2G5+htQlVABS2/OVvtZWSeX4IUIeo3YamQcUFWByEk0B237WwbZUZtt4SiEpkDFXkirtev52QREh/ap3OdmQ+iL04OaWqsiboxeQDQ7xLWw/SH4Twzi2gJSsOpzlHQQ+sD9g/SnJ9dIjliPyMZB9K7YaRdwdFPuaMogmAqMb16k1nAgMBAAECggEAJlGv/n9ZEnVpMNWlTLjd3P4TgyuZ2+LY1EdUjiJ1s+msmV/RDjgSJGJ2VR7YQDeHg+7W7sY5tf49lovIsB751i7VzYaQfYXniPDVWZUoOOb7EeawGpfPWp2Mgs71MeT1Z5gmzxXq3+jeq7FSy6918IqaGYPLs597KDOkVxx0Fzuuc8BnVeOHiYh9hVGOdKCs6hvFFBtN4PWRuRqC7CyeLlJTd/I4QE4uf3tl4mSMCaoKNOcoa4NnR6CvkwEQQqYVhnJoA8dxBwiYEVbDmM6vrFJgo2hBV0xcMNUvvVqg1pkZjuxuBXmDkcakpTTCKaCUUWEPk0Wa2w6B5783/cb8UQKBgQDzPyVzVO6p3S9ZZJCqSwy9MBJw/8TQvmR4DRpSE/kLiuYs7rJIzjFhyWp4rFHrp2AdkAP9EznjVBFc8FlqI27b4lmEDFDe5Ep06rq3D+ESYjXrqKxFLp6UCGvM+orRjtaYT1GaAUQUBkTKzOG58IJRLI+s3hyDw/pgrhCFXzmz0wKBgQCyH26UVsRFmbmMxX4WIdzfBh+rEq2jgm0k9zO/xALkTK+x6u/qkKElO5eIZWOxqaboxddhpDU86uRcX89rkQliIx5NnFGrsnfKtd5Ew+iJ9nNUg9jPtdpPcDX2EqHG+nFRvfka+tWVj8LKIRFvJXB0VXSsWU/CUcrxR+VQB4rHnQKBgDT+fuQ/jreHLrelBzdynlXhUUM5FeH8eNsGz8MuAsYW/sqvPjxKX8vUG9QqhrZ2gqQuKhBKzgPO3vGGk5RiH9bb23C/VicZSXdrZD5ZwUlGCEVNPCreW0IZC5NeyjuZiPsp3LdWq0RJkVc1h8AAvAN/V9Xrlf7HBZdmlMbZ1jJtAoGBAIZbQzPNRvsg+1790R+sp0fq/JQz4JoHVYCenoA1v+CpH5XamuGZ+pN1IdYWdF6ck3PdV5slG6s5mss60eBXZHaL+t2b3dbfJZDYIjJIe+0k4tWLJk125JcrEujsIO9QFY4M+AurzNOlvs5spxPpb6uwkfM24vy2aZgaHRSCu+HZAoGBANlpYD+TEHtGgEGSO4F6iJlCaJCQ9sg0eiRhntgYmj2rK2cuOQMpdjY1b224yw/bEPb99Z4RwhzlbbTuIBQkQIjnhCgcThrCS2xQaaeQ8l790JOGuhIXkRT1leIWHTiJIkPDtaGPnEEDoWEe3pbs1q+3yK5E/KNsfMJVdUh4Vc6m";
}

-(NSString*)getServicePublicKey{
    return @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqT/Fwc8QJT2EpTHUN946jeM7D69XvWpk8xAg8am7cWkUYGq8BhetZocadXqN8QVGWTRBy9jPPy39QMqbIyfjYUi0MlDqthhPe12EKkdSDmjl0z3Vt74yNqxO0V+MExWfh+CAw2KvvG7PC7KK3ppFFL9YyTPiLUH9Kj/GxH2oNhufobUJVQAUtvzlb7WVknl+CFCHqN2GpkHFBVgchJNAdt+1sG2VGbbeEohKZAxV5Iq7Xr+dkERIf2qdznZkPoi9ODmlqrIm6MXkA0O8S1sP0h+E8M4toCUrDqc5R0EPrA/YP0pyfXSI5Yj8jGQfSu2GkXcHRT7mjKIJgKjG9epNZwIDAQAB";
}

@end
