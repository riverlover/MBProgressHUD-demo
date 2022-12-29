//
//  UIViewController+MBShowUIData.m
//  MBProgressHUD-demo
//
//  Created by 李真河 on 2022/12/28.
//

#import "UIViewController+MBShowUIData.h"
#import "MBProgressHUD+JDragon.h"

@implementation UIViewController (MBShowUIData)
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
-(void)showHUDWhile:(SEL)method isload:(BOOL)is_View{
    [self addHUDAnimationWithText:nil method:method isload:is_View];
}

-(void)showHUDWhile:(SEL)method text:(NSString *)text isload:(BOOL)is_View{
    
    [self addHUDAnimationWithText:text method:method isload:is_View];
}

-(void)addHUDAnimationWithText:(NSString *)text method:(SEL)method isload:(BOOL)is_View{
    
    //    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    //    HUD.delegate = self;
    //    [self.view bringSubviewToFront:HUD];
    //    [HUD showAnimated:YES];
    //    HUD.backgroundColor = [UIColor whiteColor];
    //    UIImageView *customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_popup_loading"]];
    //    [customView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.width.height.mas_equalTo(80);
    //    }];
    //    HUD.mode = MBProgressHUDModeCustomView;
    //    HUD.customView = customView;
    //    UIImageView *animation = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-1"]];
    //    [customView addSubview:animation];
    //    [animation sizeToFit];
    //    [animation mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.center.equalTo(customView);
    //    }];
    //
    //
    //    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    //    ani.toValue = @(M_PI * 2);
    //    ani.fromValue = [NSNumber numberWithFloat:0.0]; // 起始角度
    //    ani.duration = 1;
    //    ani.repeatCount = MAXFLOAT;
    //    ani.removedOnCompletion = NO;
    //    [animation.layer addAnimation:ani forKey:nil];
    //    UILabel *textLab = [[UILabel alloc]init];
    //    [customView addSubview:textLab];
    //    [textLab mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.equalTo(customView);
    //        make.top.equalTo(customView.mas_bottom).offset(5);
    //    }];
    //    textLab.text = text;
    //    textLab.textColor = [UIColor blackColor];
    //    textLab.font = [UIFont systemFontOfSize:14];
    if (is_View) {
        [MBProgressHUD showActivityMessageInView:text];
    }else {
        [MBProgressHUD showActivityMessageInWindow:text];
    }
    if ([self respondsToSelector:method]) {
        [self performSelector:method];
    }
}
-(void)showHUDAnimationWhile:(SEL)method isload:(BOOL)is_View hint:(NSString *)hint{
    [MBProgressHUD ShowAnimationIconHint:hint isload:is_View];
    if ([self respondsToSelector:method]) {
        [self performSelector:method];
    }
}
-(void)hide_SC_HUD{
    [MBProgressHUD hide_SC_HUD];
}
-(void)hideAnimationHUD{
    [MBProgressHUD hideAnimationHUD];
}
-(void)showErrorWithResponseDictionary:(NSDictionary *)responseDictionary{
    [self dismiss];
    if (![responseDictionary[@"msg"] isEqualToString:@""]) {
        [MBProgressHUD showErrorMessage:responseDictionary[@"msg"]];
    }
}
-(void)showMsgWithResponseDictionary:(NSDictionary *)responseDictionary{
    [self dismiss];
    if (![responseDictionary[@"msg"] isEqualToString:@""]) {
        [MBProgressHUD showSuccessMessage:responseDictionary[@"msg"]];
    }
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:2];
}
-(void)dismiss
{
    [MBProgressHUD hideHUDForView:self animated:YES];
    
}
#pragma mark---获取当前控制器
- (UIViewController *)getCurrentVC {
    
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    if (!window) {
        return nil;
    }
    UIView *tempView;
    for (UIView *subview in window.subviews) {
        if ([[subview.classForCoder description] isEqualToString:@"UILayoutContainerView"]) {
            tempView = subview;
            break;
        }
    }
    if (!tempView) {
        tempView = [window.subviews lastObject];
    }
    
    id nextResponder = [tempView nextResponder];
    while (![nextResponder isKindOfClass:[UIViewController class]] || [nextResponder isKindOfClass:[UINavigationController class]] || [nextResponder isKindOfClass:[UITabBarController class]]) {
        tempView =  [tempView.subviews firstObject];
        
        if (!tempView) {
            return nil;
        }
        nextResponder = [tempView nextResponder];
    }
    return  (UIViewController *)nextResponder;
}

-(UINavigationController *)currentNC
{
    if (![[UIApplication sharedApplication].windows.lastObject isKindOfClass:[UIWindow class]]) {
        NSAssert(0, @"未获取到导航控制器");
        return nil;
    }
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self getCurrentNCFrom:rootViewController];
}
//递归
- (UINavigationController *)getCurrentNCFrom:(UIViewController *)vc
{
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UINavigationController *nc = ((UITabBarController *)vc).selectedViewController;
        return [self getCurrentNCFrom:nc];
    }
    else if ([vc isKindOfClass:[UINavigationController class]]) {
        if (((UINavigationController *)vc).presentedViewController) {
            return [self getCurrentNCFrom:((UINavigationController *)vc).presentedViewController];
        }
        return [self getCurrentNCFrom:((UINavigationController *)vc).topViewController];
    }
    else if ([vc isKindOfClass:[UIViewController class]]) {
        if (vc.presentedViewController) {
            return [self getCurrentNCFrom:vc.presentedViewController];
        }
        else {
            return vc.navigationController;
        }
    }
    else {
        NSAssert(0, @"未获取到导航控制器");
        return nil;
    }
}
-(NSString*)getCurrentVersion{
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
            NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    return currentVersion;
}
@end
