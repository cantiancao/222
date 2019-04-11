//
//  PCPocketPageScrollView.m
//  pcauto_pocket
//
//  Created by pconline on 2017/8/30.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "PCPocketPageScrollView.h"

@implementation PCPocketPageScrollView


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
  // 首先判断otherGestureRecognizer是不是系统pop手势
  if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
    // 再判断系统手势的state是began还是fail，同时判断scrollView的位置是不是正好在最左边
    if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.contentOffset.x == 0) {
      return YES;
    }
  }
  
  return NO;
}

@end
