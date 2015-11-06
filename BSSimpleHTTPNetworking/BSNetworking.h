//
//  BSNetworking.h
//  BSSimpleHTTPNetworkingDemo
//
//  Created by juxingzhutou on 15/11/6.
//  Copyright © 2015年 bluntsword. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BSNetworkReachability) {
    BSNetworkReachabilityUnknown          = -1,
    BSNetworkReachabilityNotReachable     = 0,
    BSNetworkReachabilityReachableViaWWAN = 1,
    BSNetworkReachabilityReachableViaWiFi = 2,
};

typedef void (^BSOnHTTPRequestSuccess)(id responseObject);
typedef void (^BSOnHTTPRequestFailure)(NSHTTPURLResponse *response, id responseObject, NSError *error);

/**
 *  Item允许的数据组合：
 *  1. formData + name
 *  2. fileData + name + fileName + mimeType
 *  3. fileURL + name
 *  4. fileURL + name + fileName + mimeType
 *  5. inputStream + name + fileName + length + mimeType
 *  6. headers + body
 */
@interface BSHTTPMultipartItem : NSObject

@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic, strong) NSInputStream *inputStream;
@property (nonatomic, strong) NSData *fileData;
@property (nonatomic, strong) NSData *formData;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *mimeType;
@property (nonatomic, assign) int64_t   length;

@property (nonatomic, strong) NSDictionary  *headers;
@property (nonatomic, strong) NSData        *body;

@end




@interface BSNetworking : NSObject

@property (nonatomic, assign) BSNetworkReachability networkReachability;
@property (nonatomic, strong) NSString *defaultBaseURLString;

+ (instancetype)sharedInstance;

#pragma mark - HTTP GET

/**
 *  通过HTTP协议的GET方法获取数据
 *  回调函数中的responseObject在响应类型为JSON和Image时可以被自动解析为相应对象，其他类型的数据会以NSData的形式返回
 *
 *  @param relativeURLString 相对于默认baseURL的相对URL字符串
 *  @param params            请求参数
 *  @param onSuccess         请求成功的回调函数
 *  @param onFailure         请求失败的回调函数，包括客户端失败、返回的status code不等于200
 */
- (void)httpGetByDefaultBaseUrlWithRelativeURL:(NSString *)relativeURLString
                                        params:(NSDictionary *)params
                                     onSuccess:(BSOnHTTPRequestSuccess)onSuccess
                                     onFailure:(BSOnHTTPRequestFailure)onFailure;

/**
 *  通过HTTP协议的GET方法获取数据
 *  回调函数中的responseObject在响应类型为JSON和Image时可以被自动解析为相应对象，其他类型的数据会以NSData的形式返回
 *
 *  @param urlString 绝对URL字符串
 *  @param params    请求参数
 *  @param onSuccess 请求成功的回调函数
 *  @param onFailure 请求失败的回调函数，包括客户端失败、返回的status code不等于200
 */
- (void)httpGetWithAbsoluteURL:(NSString *)urlString
                        params:(NSDictionary *)params
                     onSuccess:(BSOnHTTPRequestSuccess)onSuccess
                     onFailure:(BSOnHTTPRequestFailure)onFailure;

/**
 *  通过HTTP协议的GET方法获取数据
 *  回调函数中的responseObject在响应类型为JSON和Image时可以被自动解析为相应对象，其他类型的数据会以NSData的形式返回
 *
 *  @param relativeURLString 相对URL字符串
 *  @param baseURLString     baseURL字符串
 *  @param params            请求参数
 *  @param onSuccess         请求成功的回调函数
 *  @param onFailure         请求失败的回调函数，包括客户端失败、返回的status code不等于200
 */
- (void)httpGetWithRelativeURL:(NSString *)relativeURLString
                 relativeToURL:(NSString *)baseURLString
                        params:(NSDictionary *)params
                     onSuccess:(BSOnHTTPRequestSuccess)onSuccess
                     onFailure:(BSOnHTTPRequestFailure)onFailure;

#pragma mark - HTTP POST

/**
 *  通过HTTP协议的POST方法获取数据
 *  回调函数中的responseObject在响应类型为JSON和Image时可以被自动解析为相应对象，其他类型的数据会以NSData的形式返回
 *
 *  @param relativeURLString 相对于默认baseURL的相对URL字符串
 *  @param params            请求参数
 *  @param onSuccess         请求成功的回调函数
 *  @param onFailure         请求失败的回调函数，包括客户端失败、返回的status code不等于200
 */
- (void)httpPostByDefaultBaseUrlWithRelativeURL:(NSString *)relativeURLString
                                         params:(NSDictionary *)params
                                      onSuccess:(BSOnHTTPRequestSuccess)onSuccess
                                      onFailure:(BSOnHTTPRequestFailure)onFailure;

/**
 *  通过HTTP协议的POST方法获取数据
 *  回调函数中的responseObject在响应类型为JSON和Image时可以被自动解析为相应对象，其他类型的数据会以NSData的形式返回
 *
 *  @param urlString 绝对URL字符串
 *  @param params    请求参数
 *  @param onSuccess 请求成功的回调函数
 *  @param onFailure 请求失败的回调函数，包括客户端失败、返回的status code不等于200
 */
- (void)httpPostWithAbsoluteURL:(NSString *)urlString
                         params:(NSDictionary *)params
                      onSuccess:(BSOnHTTPRequestSuccess)onSuccess
                      onFailure:(BSOnHTTPRequestFailure)onFailure;

/**
 *  通过HTTP协议的POST方法获取数据
 *  回调函数中的responseObject在响应类型为JSON和Image时可以被自动解析为相应对象，其他类型的数据会以NSData的形式返回
 *
 *  @param relativeURLString 相对于baseURL的相对URL字符串
 *  @param baseURLString     baseURL字符串
 *  @param params            请求参数
 *  @param onSuccess         请求成功的回调函数
 *  @param onFailure         请求失败的回调函数，包括客户端失败、返回的status code不等于200
 */
- (void)httpPostWithRelativeURL:(NSString *)relativeURLString
                  relativeToURL:(NSString *)baseURLString
                         params:(NSDictionary *)params
                      onSuccess:(BSOnHTTPRequestSuccess)onSuccess
                      onFailure:(BSOnHTTPRequestFailure)onFailure;

#pragma mark - Multipart Upload

/**
 *  通过HTTP POST协议上传Multipart报文
 *  主要用于上传文件
 *
 *  @param multipartItems    Multipart中的数据Item集合，类型为BSHTTPMultipartItem
 *  @param params            请求参数
 *  @param absoluteURLString 绝对URL字符串
 *  @param progress          进度监控
 *  @param onSuccess         请求成功的回调函数
 *  @param onFailure         请求失败的回调函数，包括客户端失败、返回的status code不等于200
 */
- (void)httpUploadMultipartData:(NSArray *)multipartItems
                     parameters:(NSDictionary *)params
              AbsoluteURLString:(NSString *)absoluteURLString
                       progress:(NSProgress * __autoreleasing *)progress
                      onSuccess:(BSOnHTTPRequestSuccess)onSuccess
                      onFailure:(BSOnHTTPRequestFailure)onFailure;

@end