//
//  UIView+PCFrame.m
//  RefrshDemo
//
//  Created by pconline on 2017/8/10.
//  Copyright © 2017年 cqut. All rights reserved.
//

#import "UIView+PCFrame.h"

@implementation UIView (PCFrame)

- (void)setPc_x:(CGFloat)pc_x
{
    CGRect frame = self.frame;
    frame.origin.x = pc_x;
    self.frame = frame;
}

- (CGFloat)pc_x
{
    return self.frame.origin.x;
}

- (void)setPc_y:(CGFloat)pc_y
{
    CGRect frame = self.frame;
    frame.origin.y = pc_y;
    self.frame = frame;
}

- (CGFloat)pc_y
{
    return self.frame.origin.y;
}

- (void)setPc_w:(CGFloat)pc_w
{
    CGRect frame = self.frame;
    frame.size.width = pc_w;
    self.frame = frame;
}

- (CGFloat)pc_w
{
    return self.frame.size.width;
}

- (void)setPc_h:(CGFloat)pc_h
{
    CGRect frame = self.frame;
    frame.size.height = pc_h;
    self.frame = frame;
}

- (CGFloat)pc_h
{
    return self.frame.size.height;
}

- (void)setPc_size:(CGSize)pc_size
{
    CGRect frame = self.frame;
    frame.size = pc_size;
    self.frame = frame;
}

- (CGSize)pc_size
{
    return self.frame.size;
}

- (void)setPc_origin:(CGPoint)pc_origin
{
    CGRect frame = self.frame;
    frame.origin = pc_origin;
    self.frame = frame;
}

- (CGPoint)pc_origin
{
    return self.frame.origin;
}


- (void)setCornerWithCornerRadii:(CGSize)cornerRadii byRoundingCorners:(UIRectCorner)corner{
  UIBezierPath *maskPath;
  maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                   byRoundingCorners:corner
                                         cornerRadii:cornerRadii];
  CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
  maskLayer.frame = self.bounds;
  maskLayer.path = maskPath.CGPath;
  
  self.layer.mask = maskLayer;
}

- (void)addTarget:(id)target tapAction:(SEL)action {
  self.userInteractionEnabled = YES;
  UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
  [self addGestureRecognizer:gesture];
}


@end
