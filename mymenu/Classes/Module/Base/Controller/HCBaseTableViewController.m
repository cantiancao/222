//
//  HCBaseTableViewController.m
//  eHomeClient
//
//  Created by MAC mini on 2017/10/26.
//  Copyright © 2017年 YJLZ. All rights reserved.
//

#import "HCBaseTableViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "HCHudTool.h"
@interface HCBaseTableViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end
@implementation HCBaseTableViewController
#pragma mark - LifeCycle
- (void)dealloc {}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.tableView.mj_header.automaticallyChangeAlpha = NO;
    self.page = 1;//分页请求默认是第一页请求
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - Public
///让子类去实现请求
- (void)requstData{};
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}
#pragma mark - Private

#pragma mark ---- 网络请求显示视图  ----点击视图再次请求
- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView
{
    self.error = nil;
    [self.tableView reloadEmptyDataSet];
    [self requstData];
}
- (void)hc_addRefresh{
    // 下拉刷新
    self.tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requstData];
        [self.tableView.mj_footer resetNoMoreData];
    }];
}
- (void)hc_addLoadMore{
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requstData];
        [self.tableView.mj_footer resetNoMoreData];
    }];
    
}
//请求成功后停止mjfresh动画
- (void)hc_stopRefreshWithDataArr:(NSArray *)dataArr{
    if (dataArr.count == 0) {
        self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        [self.tableView.mj_header endRefreshing];
        [[HCHudTool sharedHUDTool] showProgressHUDInView:self.view tip:@"已经没有数据了~"];
    }else{
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }
    [self.tableView reloadData];
}
//网络不好请求失败后点击重新请求
- (void)hc_failRequestWitherror:(NSError *)error{
    self.error = error;
    [self.tableView reloadEmptyDataSet];
}
#pragma mark - tableView代理
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([kSystemVersion doubleValue]>= 7.0) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        if ([kSystemVersion doubleValue]>= 8.0) {
            if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
                [cell setPreservesSuperviewLayoutMargins:NO];
            }
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
        }
    }
    
}
#pragma mark - 懒加载
/** 设置刷新类型*/
- (void)setRefreshType:(NHBaseTableVcRefreshType)refreshType {
    _refreshType = refreshType;
    switch (refreshType) {
        case NHBaseTableVcRefreshTypeNone: // 没有刷新
            break ;
        case NHBaseTableVcRefreshTypeOnlyCanRefresh: { // 只有下拉刷新
            [self hc_addRefresh];
        } break ;
        case NHBaseTableVcRefreshTypeOnlyCanLoadMore: { // 只有上拉加载
            [self hc_addLoadMore];
        } break ;
        case NHBaseTableVcRefreshTypeRefreshAndLoadMore: { // 下拉和上拉都有
            [self hc_addRefresh];
            [self hc_addLoadMore];
        } break ;
        default:
            break ;
    }
}
/**
 *  加载tableview
 */
- (UITableView *)tableView {
    if(!_tableView){
        UITableView *tab = [[UITableView alloc] initWithFrame:_tableView.frame style:UITableViewStylePlain];
        [self.view addSubview:tab];
        _tableView = tab;
        tab.dataSource = self;
        tab.delegate = self;
        tab.emptyDataSetDelegate = self;
        tab.emptyDataSetSource = self;
        tab.backgroundColor = UIColorHex(kTableViewBackcolor);
        [self.view addSubview:tab];
        //没有数据cell的遮盖
        UIView *zheZhaoView = [[UIView alloc]init];
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, kScreenWidth, 30)];
//        label.text = @"别扯了,人家是有底线~";
//        label.textColor = [UIColor lightGrayColor];
//        label.font = [UIFont systemFontOfSize:14];
//        label.textAlignment = NSTextAlignmentCenter;
//        [zheZhaoView addSubview:label];
        zheZhaoView.backgroundColor = UIColorHex(kTableViewBackcolor);
        tab.tableFooterView = zheZhaoView;
    }
    return _tableView;
}
-(NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}
- (NHCustomCommonEmptyView *)emptyView {
    if (!_emptyView) {
        NHCustomCommonEmptyView *empty = [[NHCustomCommonEmptyView alloc] initWithTitle:@"" secondTitle:@"" iconname:@""];
        [self.view addSubview:empty];
        _emptyView = empty;
    }
    return _emptyView;
}
@end
