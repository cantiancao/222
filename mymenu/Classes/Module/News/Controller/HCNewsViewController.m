//
//  HCNewsViewController.m
//  mymenu
//
//  Created by zcp on 2018/8/27.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import "HCNewsViewController.h"
#import "HCNewsCell.h"
@interface HCNewsViewController ()

@end

@implementation HCNewsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"资讯";
    self.view.backgroundColor = UIColorHex(kTableViewBackcolor);
    //tableView
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-KNaviBarHeight);
    self.refreshType = NHBaseTableVcRefreshTypeRefreshAndLoadMore;
    
    [self requstData];
}
- (void)requstData {
    NSDictionary *param = @{
                            @"pageIndex" : [NSString stringWithFormat:@"%d",self.page],
                            @"pageSize" : @"10"
                            };
    [[HCNetworkTool sharedNetworkTool] POSTLoginWithUrlString:@"http://188z20966o.iok.la:41428/article/infoList.htm" parameters:param successBlock:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        ++self.page;
        NSArray *tempArr = responseObject;
        [self.dataList addObjectsFromArray:[tempArr copy]];
//        if (self.dataList.count == 0) {
//            [self.tableView removeFromSuperview];
//            [self.emptyView showInView:self.view WithTitle:@"" secondTitle:@"暂时没有合作商家" iconname:@"home_img_picture2"];
//        }else{
//            [self.emptyView removeFromSuperview];
//        }
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
    HCNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HCNewsCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"HCNewsCell" owner:nil options:nil] lastObject];
    }
    NSDictionary *dict = self.dataList[indexPath.row];
    NSArray *imgs= dict[@"imgUrlList"];
    if (imgs.count == 1) {
        [cell.firstimg sd_setImageWithURL:[NSURL URLWithString:imgs[0]] placeholderImage:nil];
    }
    if (imgs.count == 2) {
        [cell.firstimg sd_setImageWithURL:[NSURL URLWithString:imgs[0]] placeholderImage:nil];
        [cell.secondimg sd_setImageWithURL:[NSURL URLWithString:imgs[1]] placeholderImage:nil];
    }
    if (imgs.count == 3) {
        [cell.firstimg sd_setImageWithURL:[NSURL URLWithString:imgs[0]] placeholderImage:nil];
        [cell.secondimg sd_setImageWithURL:[NSURL URLWithString:imgs[1]] placeholderImage:nil];
        [cell.threeimg sd_setImageWithURL:[NSURL URLWithString:imgs[2]] placeholderImage:nil];
    }
    cell.namel.text = dict[@"title"];
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
    return 120;
}

@end
