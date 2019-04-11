//
//  HCWebViewController.m
//  eHomeClient
//
//  Created by MAC mini on 2017/2/27.
//  Copyright © 2017年 YJLZ. All rights reserved.
//

#import "HCWebViewController.h"

//#import "HCLoginController.h"
//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKUI/ShareSDK+SSUI.h>
//// 自定义分享菜单栏需要导入的头文件
//#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
////自定义分享编辑界面所需要导入的头文件
//#import <ShareSDKUI/SSUIEditorViewStyle.h>

@interface HCWebViewController ()<UIWebViewDelegate> {
    BOOL theBool;
    NSTimer *myTimer;
}
//设置加载进度条
@property (nonatomic,strong) UIProgressView *progressView;
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic, strong) JSContext *context;
@end

@implementation HCWebViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = self.webView;
    self.title = self.naviTitle;
    self.automaticallyAdjustsScrollViewInsets=YES;
    //添加进度条
    [self.view addSubview:self.progressView];
//    //导航栏右边按钮(区分有没有分享)
//    if ([self.naviTitle isEqualToString:@"加载中..."]) {
//        UIImage *image = [UIImage imageNamed:@"public_icon_share_black"];
//        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnDidClick)];
//    }
//    __block typeof(self) weakSelf = self;
//    //从热门话题登录后回调
//    self.loginBackBlock = ^{
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@&Mobileno=%@&Usertype=%@&Token=%@&Reqtime=%@&PlateType=ejx",weakSelf.url,KMobileno,KUsertype,KToken, KTimestamp]];
//        NSURLRequest *request = [NSURLRequest requestWithURL:url];
//        [weakSelf.webView loadRequest:request];
//    };
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 移除 progress view
    [_progressView removeFromSuperview];
}
#pragma mark - webView代理
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    theBool = true;
    NSLog(@"%@",[self.webView stringByEvaluatingJavaScriptFromString:@"document.title"]);
    NSLog(@"%@",[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.innerText"]);
 
    NSURLRequest *request = webView.request;
    NSURL *url = [request URL];
    if ([url.path isEqualToString:@"/normal.html"]) {
        NSLog(@"isEqualToString");
    }
    //JS交互
    self.context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    __block typeof(self) weakSelf = self;
//    self.context[@"goLogin"] = ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf.navigationController pushViewController:[HCLoginController new] animated:YES];
//        });
//    };
    //因为（加载...）是可以不隐藏分享按钮，（加载..）是系统消息传的naviTitle，区别不能分享
    if ([self.naviTitle isEqualToString:@"加载中..."] || [self.naviTitle isEqualToString:@"加载中.."]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"].length==0?@"详情":[self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
            
        });
    }
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    _progressView.progress = 0;
    theBool = false;
    //0.01667 is roughly 1/60, so it will update at 60 FPS
    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.01667 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
}
#pragma mark - 私有方法
-(void)timerCallback {
    if (theBool) {
        if (_progressView.progress >= 1) {
            _progressView.hidden = true;
            [myTimer invalidate];
        }
        else {
            _progressView.progress += 0.1;
        }
    }
    else {
        _progressView.progress += 0.05;
        if (_progressView.progress >= 0.95) {
            _progressView.progress = 0.95;
        }
    }
}
//- (void) shareAction {
//    //设置简单分享菜单样式
//    [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSystem];
//    //1、创建分享参数
//    NSString* imageArray = self.imgStr?[NSString stringWithFormat:@"%@%@",URL_IMG,self.imgStr]:([NSString stringWithFormat:@"%@%@",URL_IMG,self.hottopicsModel.Img?self.hottopicsModel.Img : self.caseModel.img]);
//    //因为分享时text超过一定的数量会分享不了，所以要截取一段内容
//    NSString *textstr;
//    if ([self.webView stringByEvaluatingJavaScriptFromString:@"document.body.innerText"].length > 50) {
//        textstr =[[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.innerText"] substringToIndex:50];
//    } else {
//        textstr = [self.webView stringByEvaluatingJavaScriptFromString:@"document.body.innerText"];
//    }
//    //替换ejx为other
//    if (imageArray) {
//        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//        [shareParams SSDKSetupShareParamsByText:self.activityStr?self.activityStr:textstr
//                                         images:imageArray
//                                            url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.shareurl]]
//                                          title:self.activityStr?@"e家修":([self.webView stringByEvaluatingJavaScriptFromString:@"document.title"].length==0?@"e家修":[self.webView stringByEvaluatingJavaScriptFromString:@"document.title"])
//                                           type:SSDKContentTypeAuto];
//        //2、分享（可以弹出我们的分享菜单和编辑界面）
//        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
//                                 items:@[@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformSubTypeQQFriend)]
//                           shareParams:shareParams
//                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//                       switch (state) {
//                           case SSDKResponseStateSuccess:
//                           {
//                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                                   message:nil
//                                                                                  delegate:nil
//                                                                         cancelButtonTitle:@"确定"
//                                                                         otherButtonTitles:nil];
//                               [alertView show];
//                               break;
//                           }
//                           case SSDKResponseStateFail:
//                           {
//                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                               message:[NSString stringWithFormat:@"%@",error]
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"OK"
//                                                                     otherButtonTitles:nil, nil];
//                               [alert show];
//                               break;
//                           }
//                           default:
//                               break;
//                       }
//                   }
//         ];}
//}
//- (void)rightBtnDidClick {
//    [self shareAction];
//}
#pragma mark - 懒加载
- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _webView.backgroundColor =  UIColorHex(@"#eeeeee");
        _webView.delegate = self;
        //加载系统消息的html富文本
        if (self.htmlStr) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",URL_IMG]];
            [_webView loadHTMLString:self.htmlStr baseURL:url];
        }else{
            NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.url]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
            [_webView loadRequest:request];
        }
    }
    return _webView;
}
- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 2);
        // 设置进度条的色彩
        [_progressView setTrackTintColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0]];
        _progressView.progressTintColor = [UIColor greenColor];
    }
    return _progressView;
}
@end
