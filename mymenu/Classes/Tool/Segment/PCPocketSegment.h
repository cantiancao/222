//
//  PCPocketSegment.h
//  pcauto_pocket
//
//  Created by pconline on 2017/8/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PCPocketSegment;

@protocol PCSegmentDelegate <NSObject>

- (void)PCSegment:(PCPocketSegment*)segment didSelectIndex:(NSInteger)index;//点击或者滑动
- (void)PCSegment:(PCPocketSegment*)segment didClickIndex:(NSInteger)index;//仅点击

@end

@interface PCPocketSegment : UIControl

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIFont *textFont;
@property (nonatomic,assign,readonly) NSInteger selectedIndex;
@property (nonatomic,weak) id<PCSegmentDelegate> delegate;
@property(nonatomic,assign) BOOL isOneChannelPage;


- (void)updateChannels:(NSArray*)array;
- (void)didChengeToIndex:(NSInteger)index;

@end
