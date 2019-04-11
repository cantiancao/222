//
//  HCMainTabbarController.m
//  eHomeClient
//
//  Created by zcp on 16/10/27.
//  Copyright © 2016年 YJLZ. All rights reserved.
//

#import "HCMainTabbarController.h"
#import "HCBaseNaviController.h"
#import "HCHomeViewController.h"
#import "HCNewsViewController.h"
#import "HCSchoolViewController.h"
#import "HCMyViewController.h"
//#import "HCExperienceController.h"
//#import "HCMyViewController.h"
@interface HCMainTabbarController ()

@end

@implementation HCMainTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tabBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    //添加tabbar子控制器
    [self setupControllersWithTitle:@"" image:@"home_normal" seletedImage:@"home_selected" controller:[HCHomeViewController new]];
    [self setupControllersWithTitle:@"" image:@"unite_buy_normal" seletedImage:@"unite_buy_selected" controller:[HCSchoolViewController new]];
    [self setupControllersWithTitle:@"" image:@"tarBar_amusement_normal" seletedImage:@"tarBar_amusement_selected" controller:[HCNewsViewController new]];
    [self setupControllersWithTitle:@"" image:@"my_lottery_normal" seletedImage:@"my_lottery_selected" controller:[HCMyViewController new]];
}

//设置标签控制器上内容
- (void)setupControllersWithTitle:(NSString *)title image:(NSString*)imageStr seletedImage:(NSString *)selectedImage controller:(UIViewController *)controller{
    
    //创建子导航控制器、Controller控制器
    controller.tabBarItem.title = title;
    [controller.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                UIColorHex(@"fe3233"), NSForegroundColorAttributeName,
                                                   nil] forState:UIControlStateSelected];
    [controller.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   UIColorHex(@"484848"), NSForegroundColorAttributeName,
                                                   nil] forState:UIControlStateNormal];
    controller.title = title;
    controller.tabBarItem.image = [[UIImage imageNamed:imageStr]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    HCBaseNaviController *na = [[HCBaseNaviController alloc]initWithRootViewController:controller];
    [self addChildViewController:na];
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    [self ItemAnimation:tabBar with:item];
}
-(void)ItemAnimation:(UITabBar *)tabbar with:(UITabBarItem *)item {
    
    NSMutableArray *array = [NSMutableArray array];
    
    Class class = NSClassFromString(@"UITabBarButton");
    for (UIView *btn in tabbar.subviews) {//遍历tabbar的子控件
        
        if ([btn isKindOfClass:class]) {//如果是系统的UITabBarButton，那么就
            for (UIView *imageView in btn.subviews) {
                if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
                    [array addObject:imageView];
                }
            }
        }
    }
    NSInteger index = [self.tabBar.items indexOfObject:item];
    //需要实现的帧动画,这里根据需求自定义
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
    animation.duration = 1;
    animation.calculationMode = kCAAnimationCubic;
    //把动画添加上去就OK了
    [[array[index] layer] addAnimation:animation forKey:nil];    
}
@end
