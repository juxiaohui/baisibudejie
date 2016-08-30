//
//  JXHNetWorkRequest.h
//  百思不得姐
//
//  Created by juxiaohui on 16/8/22.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JXH_REQUEST_TIMEOUT 20.f

#define JXH_ERROR_IMFORMATION @"网络出现错误，请检查网络连接"

#define JXH_ERROR [NSError errorWithDomain:@"com.chenchaobang.CBNetworking.ErrorDomain" code:-999 userInfo:@{ NSLocalizedDescriptionKey:JXH_ERROR_IMFORMATION}]

#define DIRECTORYPATH [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"] stringByAppendingString:@"/CBNetWorking/"];

#define MAX_CACHE_SIZE (10 * 1024 * 1024)

@interface JXHNetWorkRequest : NSObject


/**
 *  网络状态
 */
typedef NS_ENUM(NSInteger, JXHNetworkStatus) {
    /**
     *  未知网络
     */
    JXHNetworkStatusUnknown             = 1 << 0,
    /**
     *  无法连接
     */
    JXHNetworkStatusNotReachable        = 1 << 2,
    /**
     *  网络正常
     */
    JXHNetworkStatusNormal              = 1 << 3
};

/**
 *  请求方式
 */
typedef NS_ENUM(NSInteger, JXHRequestType) {
    /**
     *  POST方式来进行请求
     */
    JXHPOSTRequest = 1 << 0,
    /**
     *  GET方式来进行请求
     */
    JXHGETRequest  = 1 << 1
};

/**
 *  数据串行方式
 */
typedef NS_ENUM(NSInteger, JXHSerializerType) {
    /**
     *  HTTP方式来进行请求或响应
     */
    JXHHTTPSerializer = 1 << 0,
    /**
     *  JSON方式来进行请求或响应
     */
    JXHJSONSerializer = 1 << 1
};

/**
 *  请求任务
 */
typedef NSURLSessionTask JXHURLSessionTask;

/**
 *  成功回调
 *
 *  @param response 成功后返回的数据
 */
typedef void(^JXHResponseSuccessBlock)(id response);

/**
 *  失败回调
 *
 *  @param error 失败后返回的错误信息
 */
typedef void(^JXHResponseFailBlock)(NSError *error);

/**
 *  进度
 *
 *  @param bytesWritten              已下载或者上传进度的大小
 *  @param totalBytes                总下载或者上传进度的大小
 */
typedef void(^JXHNetWorkingProgress)(int64_t bytesRead,
                                    int64_t totalBytes);

/**
 *  配置请求头
 *
 *  @param httpHeaders 请求头参数
 */
+ (void)configHttpHeaders:(NSDictionary *)httpHeaders;

/**
 *  取消所有请求
 */
+ (void)cancelAllRequest;

/**
 *  根据url取消请求
 *
 *  @param url 请求url
 */
+ (void)cancelRequestWithURL:(NSString *)url;

/**
 *	获取缓存总大小
 *
 *	@return 缓存大小
 */
+ (unsigned long long)totalCacheSize;

/**
 *	清除缓存
 */
+ (void)clearCaches;

/**
 *	设置超时时间
 *
 *  @param timeout 超时时间
 */
+ (void)setupTimeout:(NSTimeInterval)timeout;

/**
 *  更新请求或者返回数据的解析方式(0为HTTP模式，1为JSON模式)
 *
 *  @param requestType  请求数据解析方式
 *  @param responseType 返回数据解析方式
 */
+ (void)updateRequestSerializerType:(JXHSerializerType)requestType
                 responseSerializer:(JXHSerializerType)responseType;

/**
 *  统一请求接口
 *
 *  @param url              请求路径
 *  @param params           拼接参数
 *  @param httpMethod       请求方式（0为POST,1为GET）
 *  @param useCache         是否使用缓存
 *  @param progressBlock    进度回调
 *  @param successBlock     成功回调block
 *  @param failBlock        失败回调block
 *
 *  @return 返回的对象中可取消请求
 */
+ (JXHURLSessionTask *)requestWithUrl:(NSString *)url
                              params:(NSDictionary *)params
                            useCache:(BOOL)useCache
                         httpMedthod:(JXHRequestType)httpMethod
                       progressBlock:(JXHNetWorkingProgress)progressBlock
                        successBlock:(JXHResponseSuccessBlock)successBlock
                           failBlock:(JXHResponseFailBlock)failBlock;

/**
 *  图片上传接口
 *
 *	@param image            图片对象
 *  @param url              请求路径
 *	@param name             图片名
 *	@param type             默认为image/jpeg
 *	@param params           拼接参数
 *	@param progressBlock    上传进度
 *	@param successBlock     成功回调
 *	@param failBlock		失败回调
 *
 *  @return 返回的对象中可取消请求
 */
+ (JXHURLSessionTask *)uploadWithImage:(UIImage *)image
                                  url:(NSString *)url
                                 name:(NSString *)name
                                 type:(NSString *)type
                               params:(NSDictionary *)params
                        progressBlock:(JXHNetWorkingProgress)progressBlock
                         successBlock:(JXHResponseSuccessBlock)successBlock
                            failBlock:(JXHResponseFailBlock)failBlock;

/**
 *  文件上传接口
 *
 *  @param url              上传文件接口地址
 *  @param uploadingFile    上传文件路径
 *  @param progressBlock    上传进度
 *	@param successBlock     成功回调
 *	@param failBlock		失败回调
 *
 *  @return 返回的对象中可取消请求
 */
+ (JXHURLSessionTask *)uploadFileWithUrl:(NSString *)url
                          uploadingFile:(NSString *)uploadingFile
                          progressBlock:(JXHNetWorkingProgress)progressBlock
                           successBlock:(JXHResponseSuccessBlock)successBlock
                              failBlock:(JXHResponseFailBlock)failBlock;

/**
 *  文件下载接口
 *
 *  @param url           下载文件接口地址
 *  @param saveToPath    存储目录
 *  @param progressBlock 下载进度
 *  @param successBlock  成功回调
 *  @param failBlock     下载回调
 *
 *  @return 返回的对象可取消请求
 */
+ (JXHURLSessionTask *)downloadWithUrl:(NSString *)url
                           saveToPath:(NSString *)saveToPath
                        progressBlock:(JXHNetWorkingProgress)progressBlock
                         successBlock:(JXHResponseSuccessBlock)successBlock
                            failBlock:(JXHResponseFailBlock)failBlock;





@end
