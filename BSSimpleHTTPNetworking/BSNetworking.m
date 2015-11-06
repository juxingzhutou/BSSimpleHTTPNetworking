//
//  BSNetworking.m
//  BSSimpleHTTPNetworkingDemo
//
//  Created by juxingzhutou on 15/11/6.
//  Copyright © 2015年 bluntsword. All rights reserved.
//

#import "BSNetworking.h"
#import "AFNetworking.h"

@implementation BSHTTPMultipartItem

@end

@interface BSNetworking ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation BSNetworking

+ (instancetype)sharedInstance {
    static id singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    
    return singleton;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
        self.manager = manager;
        AFCompoundResponseSerializer *serializer = [AFCompoundResponseSerializer compoundSerializerWithResponseSerializers:@[[AFJSONResponseSerializer serializer], [AFImageResponseSerializer serializer]]];
        self.manager.responseSerializer = serializer;
        
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusNotReachable:
                    self.networkReachability = BSNetworkReachabilityNotReachable;
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    self.networkReachability = BSNetworkReachabilityReachableViaWWAN;
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    self.networkReachability = BSNetworkReachabilityReachableViaWiFi;
                    break;
                default:
                    self.networkReachability = BSNetworkReachabilityUnknown;
                    break;
            }
        }];
        
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
    
    return self;
}

#pragma mark - HTTP GET

- (void)httpGetByDefaultBaseUrlWithRelativeURL:(NSString *)relativeURLString
                                        params:(NSDictionary *)params
                                     onSuccess:(BSOnHTTPRequestSuccess)onSuccess
                                     onFailure:(BSOnHTTPRequestFailure)onFailure {
    [self httpGetWithRelativeURL:relativeURLString
                   relativeToURL:self.defaultBaseURLString
                          params:params
                       onSuccess:onSuccess
                       onFailure:onFailure];
}

- (void)httpGetWithAbsoluteURL:(NSString *)urlString
                        params:(NSDictionary *)params
                     onSuccess:(BSOnHTTPRequestSuccess)onSuccess
                     onFailure:(BSOnHTTPRequestFailure)onFailure {
    [self httpGetWithRelativeURL:urlString
                   relativeToURL:nil
                          params:params
                       onSuccess:onSuccess
                       onFailure:onFailure];
}

- (void)httpGetWithRelativeURL:(NSString *)relativeURLString
                 relativeToURL:(NSString *)baseURLString
                        params:(NSDictionary *)params
                     onSuccess:(BSOnHTTPRequestSuccess)onSuccess
                     onFailure:(BSOnHTTPRequestFailure)onFailure {
    NSURL *url = nil;
    if (baseURLString == nil) {
        url = [NSURL URLWithString:relativeURLString];
    } else {
        url = [NSURL URLWithString:relativeURLString relativeToURL:[NSURL URLWithString:baseURLString]];
    }
    
    NSError *error = nil;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:url.absoluteString parameters:params error:&error];
    
#ifdef DEBUG
    if (error) {
        NSException *exception = [NSException exceptionWithName:error.description
                                                         reason:error.localizedFailureReason
                                                       userInfo:@{@"error": error}];
        @throw exception;
    }
#endif
    
    NSURLSessionDataTask *task = [self.manager dataTaskWithRequest:request
                                                 completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                     if (error
                                                         || [(NSHTTPURLResponse *)response statusCode] != 200) {
                                                         if (onFailure) {
                                                             onFailure((NSHTTPURLResponse *)response, responseObject,error);
                                                         }
                                                         return;
                                                     }
                                                     
                                                     if (onSuccess) {
                                                         onSuccess(responseObject);
                                                     }
                                                 }];
    [task resume];
}

#pragma mark - HTTP POST

- (void)httpPostByDefaultBaseUrlWithRelativeURL:(NSString *)relativeURLString
                                         params:(NSDictionary *)params
                                      onSuccess:(BSOnHTTPRequestSuccess)onSuccess
                                      onFailure:(BSOnHTTPRequestFailure)onFailure {
    [self httpPostWithRelativeURL:relativeURLString
                    relativeToURL:self.defaultBaseURLString
                           params:params
                        onSuccess:onSuccess
                        onFailure:onFailure];
}

- (void)httpPostWithAbsoluteURL:(NSString *)urlString
                         params:(NSDictionary *)params
                      onSuccess:(BSOnHTTPRequestSuccess)onSuccess
                      onFailure:(BSOnHTTPRequestFailure)onFailure {
    [self httpPostWithRelativeURL:urlString
                    relativeToURL:nil
                           params:params
                        onSuccess:onSuccess
                        onFailure:onFailure];
}

- (void)httpPostWithRelativeURL:(NSString *)relativeURLString
                  relativeToURL:(NSString *)baseURLString
                         params:(NSDictionary *)params
                      onSuccess:(BSOnHTTPRequestSuccess)onSuccess
                      onFailure:(BSOnHTTPRequestFailure)onFailure {
    NSURL *url = nil;
    if (baseURLString == nil) {
        url = [NSURL URLWithString:relativeURLString];
    } else {
        url = [NSURL URLWithString:relativeURLString relativeToURL:[NSURL URLWithString:baseURLString]];
    }
    
    NSError *error = nil;
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url.absoluteString parameters:params error:&error];
#ifdef DEBUG
    if (error) {
        NSException *exception = [NSException exceptionWithName:error.description
                                                         reason:error.localizedFailureReason
                                                       userInfo:@{@"error": error}];
        @throw exception;
    }
#endif
    
    NSURLSessionDataTask *task = [self dataTaskWithRequest:request
                                                 onSuccess:onSuccess
                                                 onFailure:onFailure];
    [task resume];
}

#pragma mark - Multipart Upload

- (void)httpUploadMultipartData:(NSArray *)multipartItems
                     parameters:(NSDictionary *)params
              AbsoluteURLString:(NSString *)absoluteURLString
                       progress:(NSProgress * __autoreleasing *)progress
                      onSuccess:(BSOnHTTPRequestSuccess)onSuccess
                      onFailure:(BSOnHTTPRequestFailure)onFailure {
    
    void (^constructingBodyBlock)(id <AFMultipartFormData> formData) = ^(id<AFMultipartFormData> formData) {
        for (BSHTTPMultipartItem *item in multipartItems) {
            if (item.fileData) {
                [formData appendPartWithFileData:item.fileData name:item.name fileName:item.fileName mimeType:item.mimeType];
            } else if (item.fileURL) {
                NSError *error = nil;
                if (item.fileName) {
                    [formData appendPartWithFileURL:item.fileURL name:item.name fileName:item.fileName mimeType:item.mimeType error:&error];
                } else {
                    [formData appendPartWithFileURL:item.fileURL name:item.name error:&error];
                }
                
#ifdef DEBUG
                if (error) {
                    NSException *exception = [NSException exceptionWithName:error.description
                                                                     reason:error.localizedFailureReason
                                                                   userInfo:@{@"error": error}];
                    @throw exception;
                }
#endif
            } else if (item.formData) {
                [formData appendPartWithFormData:item.formData name:item.name];
            } else if (item.inputStream) {
                [formData appendPartWithInputStream:item.inputStream name:item.name fileName:item.fileName length:item.length mimeType:item.mimeType];
            } else if (item.headers) {
                [formData appendPartWithHeaders:item.headers body:item.body];
            }
        }
    };
    
    NSError *requestSerializeError = nil;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
                                                                                              URLString:absoluteURLString
                                                                                             parameters:params
                                                                              constructingBodyWithBlock:constructingBodyBlock
                                                                                                  error:&requestSerializeError];
#ifdef DEBUG
    if (requestSerializeError) {
        NSException *exception = [NSException exceptionWithName:requestSerializeError.description
                                                         reason:requestSerializeError.localizedFailureReason
                                                       userInfo:@{@"error": requestSerializeError}];
        @throw exception;
    }
#endif
    
    NSURLSessionUploadTask *uploadTask = [self.manager uploadTaskWithStreamedRequest:request progress:progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error
            || [(NSHTTPURLResponse *)response statusCode] != 200) {
            if (onFailure) {
                onFailure((NSHTTPURLResponse *)response, responseObject,error);
            }
            return;
        }
        
        if (onSuccess) {
            onSuccess(responseObject);
        }
    }];
    
    [uploadTask resume];
}

#pragma mark - General

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                                    onSuccess:(BSOnHTTPRequestSuccess)onSuccess
                                    onFailure:(BSOnHTTPRequestFailure)onFailure {
    NSURLSessionDataTask *task = [self.manager dataTaskWithRequest:request
                                                 completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                     if (error
                                                         || [(NSHTTPURLResponse *)response statusCode] != 200) {
                                                         if (onFailure) {
                                                             onFailure((NSHTTPURLResponse *)response, responseObject,error);
                                                         }
                                                         return;
                                                     }
                                                     
                                                     if (onSuccess) {
                                                         onSuccess(responseObject);
                                                     }
                                                 }];
    
    return task;
}

@end

