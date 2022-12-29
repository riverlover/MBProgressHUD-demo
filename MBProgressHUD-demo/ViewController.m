//
//  ViewController.m
//  MBProgressHUD-demo
//
//  Created by 李真河 on 2022/12/28.
//


//根据类型获取轮播图
#define bannerGetByTypeApi @"parking.app.banner.getByType"

#import "ViewController.h"
#import "UIViewController+MBShowUIData.h"
#import "MBProgressHUD+MJ.h"
#import "SZHttpRequest.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:HUD];
//    HUD.label.text=@"请稍候";
//    [HUD showAnimated:YES];
//    [HUD hideAnimated:YES afterDelay:3];
//    [self showHUDWhile:@selector(show) text:@"请稍候" isload:YES];
//    [self showHUDWhile:@selector(show) isload:YES];
    //这句话没有什么显示效果, 不知道怎么用. 2022/12/28
//    [MBProgressHUD showText:@"这是一个text"];
    //快速提示一个message并有loading效果
//    [MBProgressHUD showMessage:@"这是一个message" toView:self.view];
    //这个直接显示一个loading 没有提示文字
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //提示一下错误信息, 直接消失
//    [MBProgressHUD showError:@"这是一个error" toView:self.view];
    
    
    //测试发送http请求
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"type"] = @"0";//类型（（启动页用1 首页banner用0
    [SZHttpRequest requestDataWithParam:dic businessId:bannerGetByTypeApi responseDict:^(NSDictionary * _Nonnull responseObject, BOOL responseOK) {
        [self hide_SC_HUD];

        
    }];
}
    
-(void) show{
    NSLog(@"showHUDWhile");
}


@end
