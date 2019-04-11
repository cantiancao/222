//
//  HCMycollectViewController.m
//  mymenu
//
//  Created by zcp on 2018/8/28.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import "HCMycollectViewController.h"

#import "HCHomeCell.h"
@interface HCMycollectViewController ()

@end

@implementation HCMycollectViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的收藏";
    self.view.backgroundColor = UIColorHex(kTableViewBackcolor);
    //tableView
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-KNaviBarHeight);
    self.refreshType = NHBaseTableVcRefreshTypeNone;
    
    [self requstData];
}
- (void)requstData {
    NSDictionary *param = @{
                            @"userName" : [[NSUserDefaults standardUserDefaults] stringForKey:@"userName"],
                            @"token" : [[NSUserDefaults standardUserDefaults] stringForKey:@"token"]
                            };
    [[HCNetworkTool sharedNetworkTool] POSTLoginWithUrlString:@"http://188z20966o.iok.la:41428/article/myCollect.htm" parameters:param successBlock:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *tempArr = responseObject[@"list"];
        [self.dataList addObjectsFromArray:[tempArr copy]];
                if (self.dataList.count == 0) {
                    [self.tableView removeFromSuperview];
                    [self.emptyView showInView:self.view WithTitle:@"" secondTitle:@"没有数据" iconname:@""];
                }else{
                    [self.emptyView removeFromSuperview];
                }
        //停止刷新
        [self hc_stopRefreshWithDataArr:tempArr];
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
        //请求错误回调
        [self hc_failRequestWitherror:error];
    }];
}

#pragma tableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HCHomeCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"HCHomeCell" owner:nil options:nil] lastObject];
    }
    NSDictionary *dict = [NSDictionary changeType:self.dataList[indexPath.row]];
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
    NSDictionary *dict = [NSDictionary changeType:self.dataList[indexPath.row]];
    HCWebViewController *web = [HCWebViewController new];
    web.naviTitle = @"加载中..";
    web.htmlStr = dict[@"content"];
    [self.navigationController pushViewController:web animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

@end
