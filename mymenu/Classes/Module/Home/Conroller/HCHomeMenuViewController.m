//
//  HCHomeMenuViewController.m
//  mymenu
//
//  Created by pconline on 2018/8/28.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import "HCHomeMenuViewController.h"
#import "GNRLinkageTableView.h"
@interface HCHomeMenuViewController ()
@property (nonatomic, strong)GNRLinkageTableView * goodsListView;
@end

@implementation HCHomeMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.goodsListView];
    if (self.menuid == 1) {
        self.navigationItem.title = @"早餐";
    }
    if (self.menuid == 2) {
        self.navigationItem.title = @"午餐";
    }
    if (self.menuid == 3) {
        self.navigationItem.title = @"晚餐";
    }
    if (self.menuid == 4) {
        self.navigationItem.title = @"糕点";
    }
//    [self initData];
    [self requestData];
}

- (GNRLinkageTableView *)goodsListView{
    if (!_goodsListView) {
        _goodsListView = [[GNRLinkageTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kScreenHeight-KNaviBarHeight)];
        _goodsListView.target = self;
        _goodsListView.delegate = self;
        typeof(self) __weak weakSelf = self;
        _goodsListView.cellBlock = ^(NSString *htmlstr) {
            HCWebViewController *web = [HCWebViewController new];
            web.naviTitle = @"加载中..";
            web.htmlStr = htmlstr;
            [weakSelf.navigationController pushViewController:web animated:YES];
        };
    }
    return _goodsListView;
}
- (void)requestData{
    [[HCNetworkTool sharedNetworkTool] POSTLoginWithUrlString:[NSString stringWithFormat:@"http://188z20966o.iok.la:41428/article/articleAll.htm?id=%d",self.menuid] parameters:nil successBlock:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *tempArr = responseObject;
        [tempArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GNRGoodsGroup * goodsGroup = [GNRGoodsGroup new];
            goodsGroup.classesName = [obj objectForKey:@"title"];
            NSArray * list = [obj objectForKey:@"list"];
            [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dict = [NSDictionary changeType:obj];
                
                GNRGoodsModel * goods = [GNRGoodsModel new];
                goods.title = dict[@"title"];
                goods.profile = dict[@"profile"];
                NSArray *imgs = dict[@"imgUrlList"];
                if (imgs.count>0) {
                    goods.imgUr = imgs[0];
                }
                goods.collectNum = dict[@"collectNum"];
                goods.content = dict[@"content"];
                goods.menuid = dict[@"id"];
                [goodsGroup.goodsList addObject:goods];
            }];
            [_goodsListView.goodsList.goodsGroups addObject:goodsGroup];
        }];
        [_goodsListView reloadData];
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
//- (void)initData{
//    NSArray * arr = @[
//                      @{@"title" : @"精选特卖",
//                        @"list" : @[@"甜点组合", @"毛肚", @"菌汤", @"甜点组合", @"毛肚", @"菌汤",@"甜点组合", @"毛肚", @"菌汤"]
//                        },
//                      @{@"title" : @"饭后(含有茶点)",
//                        @"list" : @[@"甜点组合", @"毛肚", @"菌汤"]
//                        },
//                      @{@"title" : @"茶点(含有茶点)",
//                        @"list" : @[@"甜点组合", @"毛肚", @"菌汤",@"甜点组合", @"毛肚", @"菌汤"]
//                        },
//                      @{@"title" : @"素材水果拼盘",
//                        @"list" : @[@"甜点组合", @"毛肚", @"菌汤",@"甜点组合", @"毛肚", @"菌汤",@"甜点组合", @"毛肚", @"菌汤",@"甜点组合", @"毛肚", @"菌汤",]
//                        },
//                      @{@"title" : @"水果拼盘生鲜果",
//                        @"list" : @[@"甜点组合", @"毛肚", @"菌汤",]
//                        },
//                      @{@"title" : @"拼盘",
//                        @"list" : @[@"甜点组合"]
//                        },
//                      @{@"title" : @"烤鱼盘",
//                        @"list" : @[@"甜点组合", @"毛肚", @"菌汤",@"甜点组合", @"毛肚", @"菌汤"]
//                        },
//                      @{@"title" : @"饮料",
//                        @"list": @[@"甜点组合", @"毛肚", @"菌汤",@"甜点组合", @"毛肚", @"菌汤",@"甜点组合", @"毛肚", @"菌汤",@"甜点组合", @"毛肚", @"菌汤"]
//                        },
//                      @{@"title": @"小吃",
//                        @"list": @[@"甜点组合", @"毛肚"]
//                        },
//                      @{@"title" : @"作料",
//                        @"list" : @[@"甜点组合", @"毛肚", @"菌汤"]
//                        },
//                      @{@"title" : @"主食",
//                        @"list" : @[@"甜点组合", @"毛肚", @"菌汤"]
//                        },
//                      ];
//
//    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        GNRGoodsGroup * goodsGroup = [GNRGoodsGroup new];
//        goodsGroup.classesName = [obj objectForKey:@"title"];
//        NSArray * list = [obj objectForKey:@"list"];
//        [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            GNRGoodsModel * goods = [GNRGoodsModel new];
//            goods.title = obj;
////            goods.profile = [NSString stringWithFormat:@"%.2f",(float)arc4random_uniform(100)+50.f];
//            [goodsGroup.goodsList addObject:goods];
//        }];
//        [_goodsListView.goodsList.goodsGroups addObject:goodsGroup];
//    }];
//    [_goodsListView reloadData];
//
//}


@end
