//
//  PCPocketSegment.m
//  pcauto_pocket
//
//  Created by pconline on 2017/8/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "PCPocketSegment.h"
#import "UIView+PCFrame.h"

#define PCPocketSegmentColor UIColorHex(@"e54017")

@interface PCPocketSegment()

@property (nonatomic,strong) NSArray *widthArray;
@property (nonatomic,assign) NSInteger allButtonW;
@property (nonatomic,strong) UIView *divideView;//移动的短分割线
@property (nonatomic,strong) UIView *divideLineView;//固定的长分割线

@end

@implementation PCPocketSegment

-(instancetype)initWithFrame:(CGRect)frame{
  
  if (self = [super initWithFrame:frame]) {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.pc_w, self.pc_h)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    [self addSubview:self.scrollView];
    
    self.divideLineView = [[UIView alloc] init];
    self.divideLineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.scrollView addSubview:self.divideLineView];
  
    self.divideView  = [[UIView alloc] init];
    self.divideView.backgroundColor = PCPocketSegmentColor;
    [self.scrollView addSubview:self.divideView];
    
  }
  
  return self;
}

- (void)updateChannels:(NSArray*)array{
  
  self.isOneChannelPage = NO;
  NSMutableArray *widthMutableArray = [NSMutableArray array];
  NSInteger totalW = 0;
  for (int i = 0; i < array.count; i++) {
    
    NSString *string = [array objectAtIndex:i];
    CGFloat buttonW = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.textFont} context:nil].size.width + 20;
    [widthMutableArray addObject:@(buttonW)];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(totalW, 0, buttonW, self.bounds.size.height-12)];
    button.tag = 1000 + i;
    [button.titleLabel setFont:self.textFont];
    [button setTitleColor:PCColor(136, 136, 136, 1) forState:UIControlStateNormal];
    [button setTitleColor:PCPocketSegmentColor forState:UIControlStateSelected];
    [button setTitle:string forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickSegmentButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:button];
    totalW += buttonW;
    
    if (i == 0) {
      [button setSelected:YES];
      self.divideView.frame = CGRectMake(0, self.scrollView.pc_h-12, buttonW, 2);
      _selectedIndex = 0;
    }
  }
  
  //如果不足屏幕宽度，平分
  if (totalW <= kScreenWidth) {
    CGFloat buttonW = kScreenWidth/array.count;
    [widthMutableArray removeAllObjects];
    UIButton *button;
    for (int i=0; i<array.count; i++) {
      button = [self.scrollView viewWithTag:1000+i];
      [button setPc_x:i*buttonW];
      [button setPc_w:buttonW];
      [widthMutableArray addObject:@(buttonW)];
      self.isOneChannelPage = YES;
    }
    totalW = kScreenWidth;
    [self.divideView setPc_w:buttonW];
  }
  
  self.allButtonW = totalW;
  self.scrollView.contentSize = CGSizeMake(totalW,0);
  self.widthArray = [widthMutableArray copy];
  self.divideLineView.frame = CGRectMake(0, self.scrollView.pc_h-10, totalW, 0);
}

-(void)clickSegmentButton:(UIButton*)selectedButton{
  [self clickSegmentButton:selectedButton click:YES];
}

- (void)clickSegmentButton:(UIButton*)selectedButton click:(BOOL)isClick{
  
  UIButton *oldSelectButton = (UIButton*)[self.scrollView viewWithTag:(1000 + _selectedIndex)];
  [oldSelectButton setSelected:NO];
  
  [selectedButton setSelected:YES];
  _selectedIndex = selectedButton.tag - 1000;
  
  NSInteger totalW = 0;
  for (int i=0; i<self.selectedIndex; i++) {
    totalW += [[self.widthArray objectAtIndex:i] integerValue];
  }
  
  //处理边界
  CGFloat selectW = [[self.widthArray objectAtIndex:_selectedIndex] integerValue];
  if (!self.isOneChannelPage) {
    CGFloat offset = totalW + (selectW - self.pc_w) *0.5 ;
    offset = MIN(self.allButtonW - self.pc_w, MAX(0, offset));
    [self.scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
  }
  
  if ([self.delegate respondsToSelector:@selector(PCSegment:didSelectIndex:)]) {
    [self.delegate PCSegment:self didSelectIndex:_selectedIndex];
  }
  
  if (isClick && [self.delegate respondsToSelector:@selector(PCSegment:didClickIndex:)]) {
    [self.delegate PCSegment:self didClickIndex:_selectedIndex];
  }
  
  //滑块动画
  __weak typeof(self) wself = self;
  [UIView animateWithDuration:0.1 animations:^{
      wself.divideView.frame = CGRectMake(totalW, wself.scrollView.pc_h-12, selectW, wself.divideView.pc_h);
  }];
  
}


- (void)didChengeToIndex:(NSInteger)index{
  
  UIButton *selectedButton = [self.scrollView viewWithTag:(1000 + index)];
  [self clickSegmentButton:selectedButton click:NO];
  
}

-(UIFont*)textFont{
  return _textFont?:[UIFont systemFontOfSize:14];
}


@end
