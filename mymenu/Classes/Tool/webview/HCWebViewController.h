//
//  HCWebViewController.h
//  eHomeClient
//
//  Created by MAC mini on 2017/2/27.
//  Copyright © 2017年 YJLZ. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "HCOneHottopicsModel.h"
//#import "HCCaseModel.h"
//#import "HCStoreModel.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface HCWebViewController : UIViewController
typedef void(^loginBackBlock)();

@property (nonatomic, copy) loginBackBlock loginBackBlock;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *shareurl;
//导航栏标题区别是加载本地文件还是网络文件（“加载中...”是加载网络HTML）
@property (nonatomic,copy) NSString *naviTitle;
@property (nonatomic,copy) NSString *htmlStr;//消息中心的详细HTML的内容
//热门话题
//@property (nonatomic,strong)HCOneHottopicsModel *hottopicsModel;
//工程案例
//@property (nonatomic,strong)HCCaseModel *caseModel;
////商家
//@property (nonatomic,strong)HCStoreModel *storeModel;

@property (nonatomic,copy) NSString *activityStr;//轮动图搞活动时活动标题
@property (nonatomic,copy) NSString *imgStr;//轮动图url
@end
