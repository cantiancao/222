//
//  HCSchoolViewController.m
//  mymenu
//
//  Created by zcp on 2018/8/27.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import "HCSchoolViewController.h"
#import "PCPocketSegment.h"
#import "PCPocketPageView.h"
#import "HCSchoolView.h"
@interface HCSchoolViewController ()<PCSegmentDelegate,PCPocketPageViewDataSource,PCPageViewDelegate>

@property(nonatomic,strong) PCPocketSegment *segment;
@property(nonatomic,strong) PCPocketPageView *pageView;
@property(nonatomic,strong) NSArray<NSString*> *channelsName;
@property(nonatomic,strong) NSArray<NSNumber*> *channelsId;

@end

@implementation HCSchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    [self getChannel];
    [self setUpChannel];
}

-(void)dealloc{
    self.segment.delegate = nil;
    self.pageView.delegate = nil;
    self.pageView.datasource = nil;
}
#pragma mark - UI
-(void)getChannel{
    self.channelsId =@[@(5),@(6),@(7)];
    self.channelsName =@[@"新手必看",@"技巧百科",@"材料介绍"];
}
- (void)setUpView{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"学堂";
}

-(void)setUpChannel{
    
    //Segment
    self.segment = [[PCPocketSegment alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    [self.segment updateChannels:self.channelsName];
    self.segment.delegate = self;
    [self.view addSubview:self.segment];
    
    //Page
    self.pageView =[[PCPocketPageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segment.frame), kScreenWidth, kScreenHeight-CGRectGetMaxY(self.segment.frame)-64)];
    self.pageView.datasource = self;
    self.pageView.delegate = self;
    [self.pageView reloadData];
    [self.pageView changeToItemAtIndex:0];
    [self.view addSubview:self.pageView];
    
}

#pragma mark - PCSegmentDelegate
- (void)PCSegment:(PCPocketSegment*)segment didSelectIndex:(NSInteger)index{
    [self.pageView changeToItemAtIndex:index];
}

-(void)PCSegment:(PCPocketSegment *)segment didClickIndex:(NSInteger)index{
}

#pragma mark - PCPageViewDataSource & Delegate
-(NSInteger)numberOfItemInPageView:(PCPocketPageView *)pageView{
    return self.channelsName.count;
}

-(UIView*)pageView:(PCPocketPageView *)pageView viewAtIndex:(NSInteger)index{
    HCSchoolView *tableView = [HCSchoolView getTabelViewWithType:[self.channelsId[index] integerValue] frame:CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(self.pageView.frame))];
    typeof(self) __weak weakSelf = self;
    tableView.schoolcellBlock = ^(NSString *htmlstr) {
        HCWebViewController *web = [HCWebViewController new];
        web.naviTitle = @"加载中..";
        web.htmlStr = htmlstr;
        [weakSelf.navigationController pushViewController:web animated:YES];
    };
    return tableView;
}

- (void)didScrollToIndex:(NSInteger)index{
    [self.segment didChengeToIndex:index];
}
@end
