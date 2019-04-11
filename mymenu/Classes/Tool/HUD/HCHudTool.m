//
//  HCHud.m
//  eHomeClient
//
//  Created by MAC mini on 2016/11/11.
//  Copyright © 2016年 YJLZ. All rights reserved.
//

#import "HCHudTool.h"
#import "MBProgressHUD.h"
@interface HCHudTool ()
@property (nonatomic,strong) MBProgressHUD *hudTool;
@end
@implementation HCHudTool

+ (instancetype)sharedHUDTool {
    static HCHudTool *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] init];
        
    });
    return instance;
}
//文字提示框
- (void)showProgressHUDInView:(UIView *)view tip:(NSString *)tip{
            MBProgressHUD *hud = self.hudTool;
            hud.userInteractionEnabled = NO;
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = tip;
            hud.detailsLabelFont = [UIFont systemFontOfSize:17];
            [hud show:YES];
            [hud hide:YES afterDelay:1];
            [view addSubview:hud];
}

//网络加载提示框
- (void)showProgressNetworkHUDInView:(UIView *)view tip:(NSString *)tip{
    if (view==nil) {
        view = (UIView*)[[[UIApplication sharedApplication]delegate]window];
    }
    MBProgressHUD *hud = self.hudTool;
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.detailsLabelText = tip;
    hud.detailsLabelFont = [UIFont systemFontOfSize:17];
    [hud show:YES];
    [view addSubview:hud ];
}
//隐藏
- (void)hide {
    MBProgressHUD *hud = self.hudTool;
    [hud hide:YES afterDelay:0.5];
}
#pragma mark - 懒加载
- (MBProgressHUD *)hudTool {
    if (_hudTool == nil) {
        _hudTool = [[MBProgressHUD alloc] init];
        _hudTool.userInteractionEnabled = NO;
        _hudTool.animationType = MBProgressHUDAnimationFade;
        [_hudTool show:YES];
    }
    return _hudTool;
}

@end
