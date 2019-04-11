//
//  HCBaseTableViewController.h
//  eHomeClient
//
//  Created by MAC mini on 2017/10/26.
//  Copyright © 2017年 YJLZ. All rights reserved.
//

#import "UIScrollView+EmptyDataSet.h"
#import "MJRefresh.h"
#import "NHCustomCommonEmptyView.h"
typedef NS_ENUM(NSUInteger, NHBaseTableVcRefreshType) {
    /** 无法刷新*/
    NHBaseTableVcRefreshTypeNone = 0,
    /** 只能下拉刷新*/
    NHBaseTableVcRefreshTypeOnlyCanRefresh,
    /** 只能上拉加载*/
    NHBaseTableVcRefreshTypeOnlyCanLoadMore,
    /** 能刷新*/
    NHBaseTableVcRefreshTypeRefreshAndLoadMore
};
@interface HCBaseTableViewController : HCBaseViewController<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
/** 加载刷新类型*/
@property (nonatomic, assign) NHBaseTableVcRefreshType refreshType;
/** 表视图*/
@property (nonatomic, weak) UITableView *tableView;
/**数据数组*/
@property (nonatomic,strong) NSMutableArray *dataList;
/**没有数据视图*/
@property (nonatomic, weak) NHCustomCommonEmptyView *emptyView;
@property (nonatomic,assign) int page;///页数

@property (nonatomic,assign) BOOL *noData;
- (void)requstData;///让子类去实现请求
///请求成功后停止mjfresh动画
- (void)hc_stopRefreshWithDataArr:(NSArray *)dataArr;
///网络不好请求失败后点击重新请求
- (void)hc_failRequestWitherror:(NSError *)error;
@end
