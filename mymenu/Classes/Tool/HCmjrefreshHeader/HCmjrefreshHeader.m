//
//  HCmjrefreshHeader.m
//  eHomeClient
//
//  Created by MAC mini on 2017/12/5.
//  Copyright © 2017年 YJLZ. All rights reserved.
//

#import "HCmjrefreshHeader.h"

@implementation HCmjrefreshHeader
- (void)prepare
{
    [super prepare];
    [self setImages:@[[UIImage imageNamed:@"e"]] forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [self setImages:@[[UIImage imageNamed:@"e"]] forState:MJRefreshStateRefreshing];
    // 创建渐变效果的layer
    CAGradientLayer *graLayer = [CAGradientLayer layer];
    graLayer.frame = CGRectMake(0, 0,kScreenWidth, 52);
    graLayer.colors = @[(__bridge id)[[UIColor greenColor] colorWithAlphaComponent:0.6].CGColor,
                        (__bridge id)[UIColor yellowColor].CGColor,
                        (__bridge id)[[UIColor yellowColor] colorWithAlphaComponent:0.6].CGColor];
    graLayer.startPoint = CGPointMake(0, 0.1);//设置渐变方向起点
    graLayer.endPoint = CGPointMake(1, 0);  //设置渐变方向终点
    graLayer.locations = @[@(0.0), @(0.0), @(0.1)]; //colors中各颜色对应的初始渐变点
    // 创建动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"locations"];
    animation.duration = 1.0f;
    animation.toValue = @[@(0.9), @(1.0), @(1.0)];
    animation.removedOnCompletion = NO;
    animation.repeatCount = HUGE_VALF;
    animation.fillMode = kCAFillModeForwards;
    [graLayer addAnimation:animation forKey:@"xindong"];
    // 将graLayer设置成textLabel的遮罩
    self.layer.mask = graLayer;
    
}
@end
