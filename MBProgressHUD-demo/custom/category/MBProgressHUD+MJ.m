//
//  MBProgressHUD+MJ.m
//  MBProgressHUD-demo
//
//  Created by 李真河 on 2022/12/28.
//

#import "MBProgressHUD+MJ.h"
#import "MBProgressHUD+JDragon.h"

@implementation MBProgressHUD (MJ)
#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    //  view = [[UIApplication sharedApplication].windows lastObject]
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    if (!icon) {
        hud.label.font = [UIFont systemFontOfSize:16.0];
    }
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 0.7秒之后再消失
//    [hud hide:YES afterDelay:1.0];
    [hud hideAnimated:YES afterDelay:1.5];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

+ (void) showText:(NSString *)text toView:(UIView *)view
{
    [self show:text icon:nil view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view netWork:(BOOL)isNetWork mask:(BOOL)isMask{
    if (view == nil) view = [[UIApplication sharedApplication].keyWindow.subviews lastObject] ;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    //    hud.dimBackground = isMask;
    //判断是否开启状态栏指示器
    [UIApplication sharedApplication].networkActivityIndicatorVisible = isNetWork;
    return hud;
}

+ (void)showMessage:(NSString *)message toView:(UIView *)view
{
    [self showMessage:message toView:view netWork:NO mask:NO];
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (void)showText:(NSString *)text
{
    [self showText:text toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil netWork:NO mask:YES];
}

+ (MBProgressHUD *)showMessage:(NSString *)message netWork:(BOOL)isNetWork
{
    return [self showMessage:message toView:nil netWork:YES mask:YES];
}

+ (BOOL)hideHUDForView:(UIView *)view
{
   return [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

+ (void)hideHUDNoAnimation
{
    [self hideHUDForView:nil];
}

+ (void)showFakeOperationActivityMessage:(NSString *)message isWindow:(BOOL)isload emessage:(NSString *)emessage{
//    [self showActivityMessage:message isWindow:isload];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(2.0* NSEC_PER_SEC)),dispatch_get_main_queue(),^{
        if (emessage.length>0) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showInfoMessage:emessage];

        }else{
            [MBProgressHUD hideHUD];
        }
    });
}
@end
