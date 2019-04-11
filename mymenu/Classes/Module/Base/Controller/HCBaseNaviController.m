//
//  HCBaseNaviController.m
//  eHomeClient
//
//  Created by zcp on 16/10/27.
//  Copyright © 2016年 YJLZ. All rights reserved.
//

#import "HCBaseNaviController.h"
#import "HCHudTool.h"
@interface HCBaseNaviController ()

@end

@implementation HCBaseNaviController

- (void)viewDidLoad {
    [super viewDidLoad];
}
+ (void)initialize {
    if (self == [HCBaseNaviController self]) {
        //获得整个项目中所有的UINavigationBar 对象
        UINavigationBar *navigationBar = [UINavigationBar appearance];
        //设置导航控制器的背景色
//        UIColorHex(@"#ff8b15");
        navigationBar.barTintColor = UIColorHex(@"#ff8b15");
        navigationBar.translucent = NO;
//        [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
//        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
        //设置字体颜色-修改title的颜色 + 字体大小
        NSDictionary *dict = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20]};
        [navigationBar setTitleTextAttributes:dict];
        
        //在获得全局的返回按钮
        //        UIBarButtonItem *backButton = [UIBarButtonItem appearance];
        //        NSDictionary *dict1 = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
        //        [backButton setTitleTextAttributes:dict1 forState:UIControlStateNormal];
        
        //设置返回按钮的箭头颜色 -- 也能修改返回按钮的字体颜色
        navigationBar.tintColor = [UIColor whiteColor];
        //自定义返回按钮
//        UIImage *backButtonImage = [[UIImage imageNamed:@"me_fh"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"me_fh"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//        //将返回按钮的文字position设置不在屏幕上显示
//        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
        [UINavigationBar appearance].backIndicatorTransitionMaskImage = [UIImage imageNamed:@"back"];
        [UINavigationBar appearance].backIndicatorImage = [UIImage imageNamed:@"back"];
//        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -260)
//                                                             forBarMetrics:UIBarMetricsDefault];
//        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
//        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(1000, 1000) forBarMetrics:UIBarMetricsDefault];
    
    }
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    //关闭跳转界面时,底部标签栏
    if (self.viewControllers.count > 0) {
        [[HCHudTool sharedHUDTool]hide];
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
@end
