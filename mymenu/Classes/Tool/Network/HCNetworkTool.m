//
//  NetworkTool.m
//  schedule
//
//  Created by zcp on 16/7/20.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "HCNetworkTool.h"
#import "HCHudTool.h"
#import "MBProgressHUD.h"

@interface HCNetworkTool ()


@end
@implementation HCNetworkTool
+ (instancetype)sharedNetworkTool {
    static HCNetworkTool *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] init];
        
    });
    return instance;
}

///  POST请求
///
///  @param urlString  urlString
///  @param parameters 请求参数
///  @param success    成功回调
///  @param failure    失败回调
- (void)POSTtWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters successBlock: (void (^)(NSURLSessionDataTask *task, id responseObject))success failureBlock: (void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    HCNetworkTool *network = [HCNetworkTool sharedNetworkTool];
    [[HCHudTool sharedHUDTool] showProgressNetworkHUDInView:nil tip:KLoadNetworkTip];
    [network.afn POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            
            success(task,responseObject);
            [[HCHudTool sharedHUDTool] hide];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task,error);
            [[HCHudTool sharedHUDTool] hide];
            [[HCHudTool sharedHUDTool] showProgressHUDInView:nil tip:@"网络不好！请重新操作！"];
        }
    }];
    
}
///GET请求
- (void)GETtWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters successBlock: (void (^)(NSURLSessionDataTask *task, id responseObject))success failureBlock: (void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    HCNetworkTool *network = [[HCNetworkTool alloc] init];
    [[HCHudTool sharedHUDTool] showProgressNetworkHUDInView:nil tip:KLoadNetworkTip];
    [network.afn GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            
            success(task,responseObject);
            [[HCHudTool sharedHUDTool] hide];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@++%@",task,error);
        
        if (failure) {
            failure(task,error);
            [[HCHudTool sharedHUDTool] hide];
            [[HCHudTool sharedHUDTool] showProgressHUDInView:nil tip:@"网络不好！请重新操作！"];
        }
    }];
    
}
//登录注册请求（因为提示不一样）
///GET请求
- (void)GETLoginWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters successBlock: (void (^)(NSURLSessionDataTask *task, id responseObject))success failureBlock: (void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    HCNetworkTool *network = [[HCNetworkTool alloc] init];
    [network.afn GET:urlString parameters:parameters progress:nil success:success failure:failure];
}
- (void)POSTLoginWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters successBlock: (void (^)(NSURLSessionDataTask *task, id responseObject))success failureBlock: (void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    HCNetworkTool *network = [[HCNetworkTool alloc] init];
    [network.afn POST:urlString parameters:parameters progress:nil success:success failure:failure];
    
}
#pragma mark - 懒加载

//http://120.24.96.104:8080/swagger/jsondata/
//http://120.24.96.104/v1/hottopics
//120.24.96.104:8080
- (AFHTTPSessionManager *)afn {
    if (_afn == nil) {
//        NSURL *basicUrl = [NSURL URLWithString:@"http://120.24.96.104/v1"];
        _afn = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
//        AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
//        [securityPolicy setAllowInvalidCertificates:YES];
//        [_afn setSecurityPolicy:securityPolicy];
//        _afn.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        _afn.requestSerializer = [AFHTTPRequestSerializer serializer];
//        _afn.responseSerializer = [AFHTTPResponseSerializer serializer];
        [_afn.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        _afn.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"application/octer-stream",@"image/jpeg", nil];
//        @"application/octer-stream",@"image/jpeg",
        [_afn.requestSerializer setTimeoutInterval:20];
    }
    return _afn;
}
@end
