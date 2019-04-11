//
//  NetworkTool.h
//  schedule
//
//  Created by zcp on 16/7/20.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface HCNetworkTool : NSObject
/**
 *  请求成功回调
 *
 *  @param returnData 回调block
 */
typedef void (^successBlock)(NSURLSessionDataTask *task, id responseObject);

/**
 *  请求失败回调
 *
 *  @param error 回调block
 */
typedef void (^failureBlock)(NSURLSessionDataTask *task, NSError *error);
/// 唯一单例
@property (nonatomic, strong) AFHTTPSessionManager *afn;
+ (instancetype)sharedNetworkTool;
///  POST请求
///
///  @param urlString  urlString
///  @param parameters 请求参数
///  @param success    成功回调
///  @param failure    失败回调
- (void)POSTtWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters successBlock: (void (^)(NSURLSessionDataTask *task, id responseObject))success failureBlock: (void (^)(NSURLSessionDataTask *task, NSError *error))failure;

///GET请求
- (void)GETtWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters successBlock: (void (^)(NSURLSessionDataTask *task, id responseObject))success failureBlock: (void (^)(NSURLSessionDataTask *task, NSError *error))failure;
//登录注册请求（因为提示不一样）
///GET请求
- (void)GETLoginWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters successBlock: (void (^)(NSURLSessionDataTask *task, id responseObject))success failureBlock: (void (^)(NSURLSessionDataTask *task, NSError *error))failure;
- (void)POSTLoginWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters successBlock: (void (^)(NSURLSessionDataTask *task, id responseObject))success failureBlock: (void (^)(NSURLSessionDataTask *task, NSError *error))failure ;
@end
