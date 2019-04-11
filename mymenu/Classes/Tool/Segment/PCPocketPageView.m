//
//  PCPocketPageView.m
//  pcauto_pocket
//
//  Created by pconline on 2017/8/22.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "PCPocketPageView.h"
#import "UIView+PCFrame.h"
#import "PCPocketPageScrollView.h"

@interface PCPocketPageView()<UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray *itemsArray;

@end

@implementation PCPocketPageView

- (instancetype)initWithFrame:(CGRect)frame{
  if (self = [super initWithFrame:frame]) {
    [self commonInit];
  }
  return self;
}


//初始化
- (void)commonInit{
  
  _scrollview = [[PCPocketPageScrollView alloc] initWithFrame:self.bounds];
  _scrollview.delegate = self;
  _scrollview.pagingEnabled = YES;
  _scrollview.bounces = NO;
  _scrollview.showsHorizontalScrollIndicator = NO;
  [self addSubview:_scrollview];
  
}

//刷新数据
- (void)reloadData{
  
  //数据源不为空的话，从数据源获取最新数据来更新
  if (nil != _datasource) {
    _numberOfItems = [self.datasource numberOfItemInPageView:self];
    _scrollview.contentSize = CGSizeMake(_numberOfItems * self.pc_w,self.pc_h);
  }
  
}

//滚到指定的某页
- (void)changeToItemAtIndex:(NSInteger)index{
  
  //如果是第一次滑动到此页，则加载
  if ([self.itemsArray objectAtIndex:index] == [NSNull null]) {
    [self loadViewAtIndex:index];
  }
  [_scrollview setContentOffset:CGPointMake(index * self.bounds.size.width, 0) animated:_scrollAnimation];
  //预加载当前页左右两页
  [self preLoadViewWithIndex:index];
  _currentIndex = index;
  
  
}

//加载指定的某页
- (void)loadViewAtIndex:(NSInteger)index{
  
  if (self.datasource != nil && [self.datasource respondsToSelector:@selector(pageView:viewAtIndex:)]) {
    UIView *view = [self.datasource pageView:self viewAtIndex:index];
    view.frame = CGRectMake(self.pc_w * index, 0, self.pc_w, self.pc_h);
    [_scrollview addSubview:view];
    [self.itemsArray replaceObjectAtIndex:index withObject:view];
  }
  
}

//预加载指定页的左右两个页面
- (void)preLoadViewWithIndex:(NSInteger)index{
  
  //左边一个页面
  if (index > 0 && [self.itemsArray objectAtIndex:(index-1)] == [NSNull null]) {
    [self loadViewAtIndex:(index-1)];
  }
  
  //右边一个页面
  if (index < (_numberOfItems-1) && [self.itemsArray objectAtIndex:(index+1)] == [NSNull null]) {
    [self loadViewAtIndex:(index+1)];
  }
  
}

#pragma mark - scrollview

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  
  //滚动到某一页
  NSInteger index = scrollView.contentOffset.x / self.bounds.size.width;
  //如果还没加载过那一页，就加载
  if ([self.itemsArray objectAtIndex:index] == [NSNull null]) {
    [self loadViewAtIndex:index];
  }
  //并且把左右的两个页面也加载
  [self preLoadViewWithIndex:index];
  
  //告诉代理，当前页改变了
  if (index != _currentIndex) {
    if ([self.delegate respondsToSelector:@selector(didScrollToIndex:)]) {
      [self.delegate didScrollToIndex:index];
      _currentIndex = index;
    }
  }
  
}


#pragma mark - getter & setter

- (NSMutableArray*)itemsArray{
  
  if (_itemsArray == nil) {
    NSInteger total = [self.datasource numberOfItemInPageView:self];
    _itemsArray = [NSMutableArray arrayWithCapacity:total];
    for (int i = 0; i < total; i++) {
      [_itemsArray addObject:[NSNull null]];
    }
  }
  return _itemsArray;
  
}



@end
