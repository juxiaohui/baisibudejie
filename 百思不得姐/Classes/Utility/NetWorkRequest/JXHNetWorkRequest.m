//
//  JXHNetWorkRequest.m
//  百思不得姐
//
//  Created by juxiaohui on 16/8/22.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "JXHNetWorkRequest.h"
#import <CommonCrypto/CommonDigest.h>
#import "AFNetworkActivityIndicatorManager.h"

@interface JXHURLCache : NSURLCache

@end

static NSString       *JXHURLCacheExpirationKey = @"CBURLCacheExpiration";

static NSTimeInterval JXHURLCacheExpirationInterval = 7 * 24 * 60 * 60;

@interface JXHURLCache()

@end

@implementation JXHURLCache


+ (instancetype)standardURLCache {
    static JXHURLCache *_standardURLCache = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _standardURLCache = [[JXHURLCache alloc]
                             initWithMemoryCapacity:MAX_CACHE_SIZE
                             diskCapacity:5 * MAX_CACHE_SIZE
                             diskPath:nil];
    });
    return _standardURLCache;
}

- (id)cachedResponseForRequest:(NSURLRequest *)request {
    NSCachedURLResponse *cachedResponse = [super cachedResponseForRequest:request];
    
    if (cachedResponse) {
        NSDate *cacheDate = cachedResponse.userInfo[JXHURLCacheExpirationKey];
        
        NSDate *cacheExpirationDate = [cacheDate dateByAddingTimeInterval:JXHURLCacheExpirationInterval];
        
        if ([cacheExpirationDate compare:[NSDate date]] == NSOrderedAscending) {
            [self removeCachedResponseForRequest:request];
            return nil;
        }
    }
    
    id responseObj = [NSJSONSerialization JSONObjectWithData:cachedResponse.data options:NSJSONReadingAllowFragments error:nil];
    
    return responseObj;
}

- (void)storeCachedResponse:(id)response
               responseObjc:(id)responseObjc
                 forRequest:(NSURLRequest *)request {
    NSData *data = [NSJSONSerialization dataWithJSONObject:responseObjc options:NSJSONWritingPrettyPrinted error:nil];
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    
    userInfo[JXHURLCacheExpirationKey] = [NSDate date];
    
    NSCachedURLResponse *modifiedCachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data userInfo:userInfo storagePolicy:0];
    
    [super storeCachedResponse:modifiedCachedResponse forRequest:request];
}

@end

static NSMutableArray      *requestTasks;

static NSMutableDictionary *headers;

static JXHNetworkStatus     networkStatus;

static NSTimeInterval      requestTimeout = JXH_REQUEST_TIMEOUT;

@implementation JXHNetWorkRequest

#pragma 任务管理
+ (NSMutableArray *)allTasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (requestTasks == nil) {
            requestTasks = [[NSMutableArray alloc] init];
        }
    });
    return requestTasks;
}

+ (void)configHttpHeaders:(NSDictionary *)httpHeaders {
    headers = httpHeaders.mutableCopy;
}

+ (void)setupTimeout:(NSTimeInterval)timeout {
    requestTimeout = timeout;
}

+ (void)cancelAllRequest {
    @synchronized(self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(JXHURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[JXHURLSessionTask class]]) {
                [task cancel];
            }
        }];
        [[self allTasks] removeAllObjects];
    };
}

+ (void)cancelRequestWithURL:(NSString *)url {
    @synchronized(self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(JXHURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[JXHURLSessionTask class]]
                && [task.currentRequest.URL.absoluteString hasSuffix:url]) {
                [task cancel];
                [[self allTasks] removeObject:task];
                return;
            }
        }];
    };
}

#pragma SESSION管理设置
+ (AFHTTPSessionManager *)manager {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    /**
     *  默认请求和返回的数据类型
     */
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    /**
     *  取出NULL值
     */
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    [serializer setRemovesKeysWithNullValues:YES];
    
    [headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj) {
            [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
    }];
    
    /**
     *  如果不设置支持类型，可能会出现如下错误：
     *
     连接出错 Error Domain=com.alamofire.error.serialization.response Code=-1016
     "Request failed: unacceptable content-type: text/html" UserInfo=
     {com.alamofire.serialization.response.error.response=<NSHTTPURLResponse: 0x7f93fad1c4b0>
     { URL: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx }
     { status code: 200, headers { .....}
     ......
     22222c22 626f6172 64696422 3a226e65 77735f73 68656875 69375f62 6273222c 22707469 6d65223a 22323031 362d3033 2d303320 31313a30 323a3435 227d5d7d>,
     NSLocalizedDescription=Request failed: unacceptable content-type: text/html}
     */
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    manager.requestSerializer.timeoutInterval = requestTimeout;
    
    [self detectNetworkStaus];
    
    if ([self totalCacheSize] > MAX_CACHE_SIZE) [self clearCaches];
    
    return manager;
}

+ (void)updateRequestSerializerType:(JXHSerializerType)requestType responseSerializer:(JXHSerializerType)responseType {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    if (requestType) {
        switch (requestType) {
            case JXHHTTPSerializer: {
                manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                break;
            }
            case JXHJSONSerializer: {
                manager.requestSerializer = [AFJSONRequestSerializer serializer];
                break;
            }
            default:
                break;
        }
    }
    if (responseType) {
        switch (responseType) {
            case JXHHTTPSerializer: {
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                break;
            }
            case JXHJSONSerializer: {
                manager.responseSerializer = [AFJSONResponseSerializer serializer];
                break;
            }
            default:
                break;
        }
    }
}

#pragma 请求业务GET,POST
+ (JXHURLSessionTask *)requestWithUrl:(NSString *)url
                              params:(NSDictionary *)params
                            useCache:(BOOL)useCache
                         httpMedthod:(JXHRequestType)httpMethod
                       progressBlock:(JXHNetWorkingProgress)progressBlock
                        successBlock:(JXHResponseSuccessBlock)successBlock
                           failBlock:(JXHResponseFailBlock)failBlock {
    AFHTTPSessionManager *manager = [self manager];
    JXHURLSessionTask *session;
    
    if (httpMethod == JXHPOSTRequest) {
        
        id response = [JXHNetWorkRequest getCacheResponseWithURL:url
                                                     params:params];
        
        successBlock && response && useCache ? successBlock(response) : nil;
        
        if (networkStatus == JXHNetworkStatusNotReachable ||  networkStatus == JXHNetworkStatusUnknown) {
            failBlock ? failBlock(JXH_ERROR) : nil;
            
            return nil;
        }
        session = [manager POST:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progressBlock) {
                progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            successBlock ? successBlock(responseObject) : nil;
            
            if (useCache) {
                [self cacheResponseObject:responseObject
                                  request:task.currentRequest
                                   params:params];
            }
            
            [[self allTasks] removeObject:task];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failBlock ? failBlock(error) : nil;
            
            [[self allTasks] removeObject:task];
        }];
        
    }else if(httpMethod == JXHGETRequest){
        
//        JXHURLCache *urlCache = [JXHURLCache standardURLCache];
//        
//        [NSURLCache setSharedURLCache:urlCache];
//        
//        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//        
//        NSCachedURLResponse *cacheResponse =  [[JXHURLCache standardURLCache] cachedResponseForRequest:request];
//        
//        if (cacheResponse) {
//            successBlock ? successBlock(cacheResponse) : nil;
//        }
//        
//        if (networkStatus == JXHNetworkStatusNotReachable ||  networkStatus == JXHNetworkStatusUnknown) {
//            failBlock ? failBlock(JXH_ERROR) : nil;
//            
//            return nil;
//        }
        
        session = [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progressBlock) {
                progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            if (responseObject) {
//                [urlCache storeCachedResponse:task.response
//                                 responseObjc:responseObject
//                                   forRequest:request];
//            }
            
            successBlock ? successBlock(responseObject) : nil;
            
            [[self allTasks] removeObject:task];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failBlock ? failBlock(error) : nil;
            
            [[self allTasks] removeObject:task];
        }];
    }
    if (session) {
        [requestTasks addObject:session];
    }
    return  session;
}

#pragma 图片，文件上传下载方法
+ (JXHURLSessionTask *)uploadWithImage:(UIImage *)image
                                  url:(NSString *)url
                                 name:(NSString *)name
                                 type:(NSString *)type
                               params:(NSDictionary *)params
                        progressBlock:(JXHNetWorkingProgress)progressBlock
                         successBlock:(JXHResponseSuccessBlock)successBlock
                            failBlock:(JXHResponseFailBlock)failBlock {
    AFHTTPSessionManager *manager = [self manager];
    
    JXHURLSessionTask *session = [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.4);
        
        NSString *imageFileName;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        formatter.dateFormat = @"yyyyMMddHHmmss";
        
        NSString *str = [formatter stringFromDate:[NSDate date]];
        
        imageFileName = [NSString stringWithFormat:@"%@.png", str];
        
        NSString *blockImageType = type;
        
        if (type.length == 0) blockImageType = @"image/jpeg";
        
        [formData appendPartWithFileData:imageData name:name fileName:imageFileName mimeType:blockImageType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progressBlock) {
            progressBlock(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock ? successBlock(responseObject) : nil;
        
        [[self allTasks] removeObject:task];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock ? failBlock(error) : nil;
        
        [[self allTasks] removeObject:task];
    }];
    
    [session resume];
    
    if (session) {
        [[self allTasks] addObject:session];
    }
    
    return session;
}

+ (JXHURLSessionTask *)uploadFileWithUrl:(NSString *)url
                          uploadingFile:(NSString *)uploadingFile
                          progressBlock:(JXHNetWorkingProgress)progressBlock
                           successBlock:(JXHResponseSuccessBlock)successBlock
                              failBlock:(JXHResponseFailBlock)failBlock {
    AFHTTPSessionManager *manager = [self manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    JXHURLSessionTask *session = nil;
    
    [manager uploadTaskWithRequest:request fromFile:[NSURL URLWithString:uploadingFile] progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progressBlock) {
            progressBlock(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [[self allTasks] removeObject:session];
        
        successBlock ? successBlock(responseObject) : nil;
        
        failBlock && error ? failBlock(error) : nil;
    }];
    
    if (session) {
        [[self allTasks] addObject:session];
    }
    
    return session;
}

+ (JXHURLSessionTask *)downloadWithUrl:(NSString *)url
                           saveToPath:(NSString *)saveToPath
                        progressBlock:(JXHNetWorkingProgress)progressBlock
                         successBlock:(JXHResponseSuccessBlock)successBlock
                            failBlock:(JXHResponseFailBlock)failBlock {
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPSessionManager *manager = [self manager];
    
    JXHURLSessionTask *session = nil;
    
    session = [manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressBlock) {
            progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL URLWithString:saveToPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [[self allTasks] removeObject:session];
        
        successBlock ? successBlock(filePath.absoluteString) : nil;
        
        failBlock && error ? failBlock(error) : nil;
    }];
    
    [session resume];
    
    if (session) {
        [[self allTasks] addObject:session];
    }
    
    return session;
}

#pragma mark - 网络状态的检测
+ (void)detectNetworkStaus {
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManager startMonitoring];
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable){
            networkStatus = JXHNetworkStatusNotReachable;
        }else if (status == AFNetworkReachabilityStatusUnknown){
            networkStatus = JXHNetworkStatusUnknown;
        }else if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi){
            networkStatus = JXHNetworkStatusNormal;
        }
    }];
}

#pragma 缓存处理
+ (void)cacheResponseObject:(id)responseObject
                    request:(NSURLRequest *)request
                     params:(NSDictionary *)params {
    if (request && responseObject && ![responseObject isKindOfClass:[NSNull class]]) {
        NSString *directoryPath = DIRECTORYPATH;
        
        NSError *error = nil;
        if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error];
        }
        
        NSString *originString = [NSString stringWithFormat:@"%@+%@",request.URL.absoluteString,params];
        
        NSString *path = [directoryPath stringByAppendingPathComponent:[self md5:originString]];
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        NSData *data = nil;
        if ([dict isKindOfClass:[NSData class]]) {
            data = responseObject;
        } else {
            data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
        }
        if (data && error == nil) {
            [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
        }
    }
}

+ (NSString *)md5:(NSString *)string {
    if (string == nil || [string length] == 0) {
        return nil;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([string UTF8String], (int)[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02x", (int)(digest[i])];
    }
    
    return [ms copy];
}

+ (id)getCacheResponseWithURL:(NSString *)url
                       params:(NSDictionary *)params {
    id cacheData = nil;
    
    if (url) {
        NSString *directoryPath = DIRECTORYPATH;
        
        NSString *originString = [NSString stringWithFormat:@"%@+%@",url,params];
        
        NSString *path = [directoryPath stringByAppendingPathComponent:[self md5:originString]];
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
        if (data) {
            cacheData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        }
    }
    return cacheData;
}

+ (unsigned long long)totalCacheSize {
    NSString *directoryPath = DIRECTORYPATH;
    
    BOOL isDir = NO;
    unsigned long long total = 0;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDir]) {
        if (isDir) {
            NSError *error = nil;
            NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:&error];
            if (error == nil) {
                for (NSString *subpath in array) {
                    NSString *path = [directoryPath stringByAppendingPathComponent:subpath];
                    NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path
                                                                                          error:&error];
                    if (!error) {
                        total += [dict[NSFileSize] unsignedIntegerValue];
                    }
                }
            }
        }
    }
    return total;
}

+ (void)clearCaches {
    NSString *directoryPath = DIRECTORYPATH;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:directoryPath error:&error];
    }
}


@end
