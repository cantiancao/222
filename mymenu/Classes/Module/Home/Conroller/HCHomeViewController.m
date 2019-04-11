//
//  HCHomeViewController.m
//  mymenu
//
//  Created by zcp on 2018/8/27.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import "HCHomeViewController.h"
#import "HCHomeCell.h"
#import "SDCycleScrollView.h"
#import "ImageCenterButton.h"
#import "HCHomeMenuViewController.h"

#define imageBtnNum 4//模块按钮个数
@interface HCHomeViewController ()<SDCycleScrollViewDelegate>
@property(nonatomic,strong)SDCycleScrollView *bannerview;
@property(nonatomic,strong)NSMutableArray *bannerTitles;
@property(nonatomic,strong)NSMutableArray *bannerHtmls;
@property(nonatomic,strong)NSMutableArray *bannerImgs;
@property(nonatomic,strong)NSArray *menulists;
@end

@implementation HCHomeViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"首页";
    self.view.backgroundColor = UIColorHex(kTableViewBackcolor);
    //tableView
    self.tableView.frame = CGRectMake(0, -(KNaviBarHeight-44), kScreenWidth, kScreenHeight-KTabbarBarHeight+20);
    self.refreshType = NHBaseTableVcRefreshTypeOnlyCanRefresh;
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 260*KfitScreenWidth)];
    SDCycleScrollView *banneer = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 180*KfitScreenWidth) delegate:self placeholderImage:nil];
    banneer.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    self.bannerview = banneer;
    [headview addSubview:banneer];
    //模块按钮
    CGFloat unitWidth = kScreenWidth / imageBtnNum;
    for (int i = 0; i < imageBtnNum; i ++) {
        ImageCenterButton *imageCenterButton = [[ImageCenterButton alloc] init];
        imageCenterButton.tag = i;
        imageCenterButton.frame = CGRectMake(unitWidth*(i%4), 180*KfitScreenWidth, unitWidth, 80*KfitScreenWidth);
        if (i == 0) {
            [imageCenterButton setImage:[UIImage imageNamed:@"组 8"] forState:UIControlStateNormal];
            [imageCenterButton setTitle:@"早餐" forState:UIControlStateNormal];
        } else if (i == 1){
            [imageCenterButton setImage:[UIImage imageNamed:@"组 9"] forState:UIControlStateNormal];
            [imageCenterButton setTitle:@"午餐" forState:UIControlStateNormal];
        } else if (i == 2){
            [imageCenterButton setImage:[UIImage imageNamed:@"组 10"] forState:UIControlStateNormal];
            [imageCenterButton setTitle:@"晚餐" forState:UIControlStateNormal];
        } else{
            [imageCenterButton setImage:[UIImage imageNamed:@"组 11"] forState:UIControlStateNormal];
            [imageCenterButton setTitle:@"糕点" forState:UIControlStateNormal];
        }
        [imageCenterButton setTitleColor:[UIColor colorWithHexString:@"#404040"] forState:UIControlStateNormal];
        imageCenterButton.titleLabel.font = [UIFont systemFontOfSize: 12];
        imageCenterButton.backgroundColor = [UIColor whiteColor];
        imageCenterButton.imageIsRound = YES;
        imageCenterButton.padding = 14;
        imageCenterButton.layer.borderColor = [[UIColor whiteColor] CGColor];
        imageCenterButton.layer.borderWidth = 0.5;
        imageCenterButton.backgroundHighlightedColor = [UIColor whiteColor];
        [imageCenterButton addTarget:self action:@selector(btndid:) forControlEvents:UIControlEventTouchUpInside];
        [headview addSubview:imageCenterButton];
    }
    self.tableView.tableHeaderView = headview;
    [self requstData];
}
- (void)requstData {
    [[HCNetworkTool sharedNetworkTool] POSTLoginWithUrlString:@"http://188z20966o.iok.la:41428/article/home.htm" parameters:nil successBlock:^(NSURLSessionDataTask *task, id responseObject) {
        [self.dataList removeAllObjects];
        [self.bannerImgs removeAllObjects];
        [self.bannerHtmls removeAllObjects];
        [self.bannerTitles removeAllObjects];
        NSDictionary *newDic = [NSDictionary changeType: responseObject];
        NSLog(@"%@",responseObject);
        self.dataList = newDic[@"popularity"];
        NSArray *banner =newDic[@"banner"];
        if (banner.count>0) {
            for (NSDictionary *dict in banner) {
                [self.bannerImgs addObject:dict[@"imgUrlList"][0]];
                [self.bannerHtmls addObject:dict[@"content"]];
                [self.bannerTitles addObject:dict[@"title"]];
            }
        }
        self.bannerview.titlesGroup = self.bannerTitles;
        self.bannerview.imageURLStringsGroup = self.bannerImgs;
        //停止刷新
        [self hc_stopRefreshWithDataArr:self.dataList];
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error");
        //请求错误回调
        [self hc_failRequestWitherror:error];
    }];
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    HCWebViewController *web = [HCWebViewController new];
    web.naviTitle = @"加载中..";
    web.htmlStr = self.bannerHtmls[index];
    [self.navigationController pushViewController:web animated:YES];
}
- (void)btndid:(UIButton *)btn {
    if (btn.tag == 0) {
        HCHomeMenuViewController *vc = [HCHomeMenuViewController new];
        vc.menuid = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (btn.tag == 1) {
        HCHomeMenuViewController *vc = [HCHomeMenuViewController new];
        vc.menuid = 2;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (btn.tag == 2) {
        HCHomeMenuViewController *vc = [HCHomeMenuViewController new];
        vc.menuid = 3;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (btn.tag == 3) {
        HCHomeMenuViewController *vc = [HCHomeMenuViewController new];
        vc.menuid = 4;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma tableViewDataSource
- ( NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"人气菜谱";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HCHomeCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"HCHomeCell" owner:nil options:nil] lastObject];
    }
    NSDictionary *dict = self.dataList[indexPath.row];
    NSArray *imgs = dict[@"imgUrlList"];
    if (imgs.count>0) {
         [cell.picimg sd_setImageWithURL:[NSURL URLWithString:imgs[0]] placeholderImage:nil];
    }
    cell.nameL.text = dict[@"title"];
    cell.descL.text = dict[@"profile"];
    cell.countL.text = [NSString stringWithFormat:@"%@",dict[@"collectNum"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataList[indexPath.row];
    HCWebViewController *web = [HCWebViewController new];
    web.naviTitle = @"加载中..";
    web.htmlStr = dict[@"content"];
    [self.navigationController pushViewController:web animated:YES];
    
    NSDictionary *param = @{
                            @"userName" : [[NSUserDefaults standardUserDefaults] stringForKey:@"userName"]?[[NSUserDefaults standardUserDefaults] stringForKey:@"userName"]:@"",
                            @"token" : [[NSUserDefaults standardUserDefaults] stringForKey:@"token"]?[[NSUserDefaults standardUserDefaults] stringForKey:@"token"]:@"",
                            @"id" : dict[@"id"]?dict[@"id"]:@""
                            };
    [[HCNetworkTool sharedNetworkTool] POSTLoginWithUrlString:@"http://188z20966o.iok.la:41428/article/articleDetail.htm" parameters:param successBlock:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100 ;
}
- (NSMutableArray *)bannerTitles{
    if (!_bannerTitles) {
        _bannerTitles = [NSMutableArray array];
    }
    return _bannerTitles;
}
- (NSMutableArray *)bannerHtmls{
    if (!_bannerHtmls) {
        _bannerHtmls = [NSMutableArray array];
    }
    return _bannerHtmls;
}
- (NSMutableArray *)bannerImgs{
    if (!_bannerImgs) {
        _bannerImgs = [NSMutableArray array];
    }
    return _bannerImgs;
}
- (NSArray *)menulists{
    if (!_menulists) {
        _menulists = [NSArray array];
    }
    return _menulists;
}
@end
