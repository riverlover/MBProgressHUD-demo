//
//  UIViewController+MBShowUIData.h
//  MBProgressHUD-demo
//
//  Created by 李真河 on 2022/12/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (MBShowUIData)
-(void)showHUDWhile:(SEL)method isload:(BOOL)is_View;
-(void)showHUDWhile:(SEL)method text:(NSString *)text isload:(BOOL)is_View;
-(void)hide_SC_HUD;
-(void)hideAnimationHUD;
-(void)showErrorWithResponseDictionary:(NSDictionary *)responseDictionary;
-(void)showMsgWithResponseDictionary:(NSDictionary *)responseDictionary;
// is_View yes 加载window上 NO 加在当前控制器的view上
-(void)showHUDAnimationWhile:(SEL)method isload:(BOOL)is_View hint:(NSString*)hint;
- (UIViewController *)getCurrentVC;
-(UINavigationController *)currentNC;
-(NSString*)getCurrentVersion;
@end

NS_ASSUME_NONNULL_END
