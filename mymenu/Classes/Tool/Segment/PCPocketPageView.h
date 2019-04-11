//
//  PCPocketPageView.h
//  pcauto_pocket
//
//  Created by pconline on 2017/8/22.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PCPocketPageScrollView;
@class PCPocketPageView;

/** 数据源 **/
@protocol PCPocketPageViewDataSource <NSObject>

- (NSInteger)numberOfItemInPageView:(PCPocketPageView*)pageView;
- (UIView*)pageView:(PCPocketPageView*)pageView viewAtIndex:(NSInteger)index;

@end

/** 代理方法 **/
@protocol PCPageViewDelegate <NSObject>

- (void)didScrollToIndex:(NSInteger)index;

@end

@interface PCPocketPageView : UIView

@property(nonatomic,strong,readonly) PCPocketPageScrollView *scrollview;
@property(nonatomic,assign,readonly) NSInteger numberOfItems;
@property(nonatomic,assign,readonly) NSInteger currentIndex;
@property(nonatomic,assign) BOOL scrollAnimation;
@property(nonatomic,weak) id<PCPocketPageViewDataSource> datasource;
@property(nonatomic,weak) id<PCPageViewDelegate> delegate;

/** 刷新数据 **/
- (void)reloadData;

/** 滑动到指定页 **/
- (void)changeToItemAtIndex:(NSInteger)index;

@end
