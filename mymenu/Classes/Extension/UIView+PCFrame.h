//
//  UIView+PCFrame.h
//  RefrshDemo
//
//  Created by pconline on 2017/8/10.
//  Copyright © 2017年 cqut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (PCFrame)

@property (assign, nonatomic) CGFloat pc_x;
@property (assign, nonatomic) CGFloat pc_y;
@property (assign, nonatomic) CGFloat pc_w;
@property (assign, nonatomic) CGFloat pc_h;
@property (assign, nonatomic) CGSize pc_size;
@property (assign, nonatomic) CGPoint pc_origin;

/**
 *  设置圆角
 **/
- (void)setCornerWithCornerRadii:(CGSize)cornerRadii byRoundingCorners:(UIRectCorner)corner;

/**
 *  添加点击事件
 **/
- (void)addTarget:(id)target tapAction:(SEL)action;
@end
