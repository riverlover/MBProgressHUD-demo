//
//  MBProgressHUD+MJ.h
//  MBProgressHUD-demo
//
//  Created by 李真河 on 2022/12/28.
//

#import <MBProgressHUD/MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (MJ)
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (void)showMessage:(NSString *)message toView:(UIView *)view;
+ (BOOL)hideHUDForView:(UIView *)view;

+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;
+ (void)showText:(NSString *)text;
+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (MBProgressHUD *)showMessage:(NSString *)message netWork:(BOOL)isNetWork;
+ (void)hideHUD;
+ (void)hideHUDNoAnimation;
@end

NS_ASSUME_NONNULL_END
