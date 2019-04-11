//
//  HCHud.h
//  eHomeClient
//
//  Created by MAC mini on 2016/11/11.
//  Copyright © 2016年 YJLZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCHudTool : NSObject
+ (instancetype)sharedHUDTool;

//文字提示框
- (void)showProgressHUDInView:(UIView *)view tip:(NSString *)tip;
//网络加载提示框
- (void)showProgressNetworkHUDInView:(UIView *)view tip:(NSString *)tip;
//隐藏
- (void)hide;
@end
