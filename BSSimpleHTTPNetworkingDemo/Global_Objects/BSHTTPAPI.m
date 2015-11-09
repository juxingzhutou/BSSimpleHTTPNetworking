//
//  BSHTTPAPI.m
//  WoDong
//
//  Created by juxingzhutou on 15/7/15.
//  Copyright (c) 2015年 renhe. All rights reserved.
//

#import "BSHTTPAPI.h"
#import "NSData+Utils.h"

@implementation BSHTTPAPI

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
        [BSNetworking sharedInstance].defaultBaseURLString = DEFAULT_BASE_URL;
    }
    
    return self;
}

- (void)uploadImageToUpYunWithUIImage:(UIImage *)image
                            uploadURL:(NSString *)uploadURLString
                               policy:(NSString *)policy
                            signature:(NSString *)signature
                             progress:(NSProgress *__autoreleasing *)progress
                            onSuccess:(BSOnHTTPRequestSuccess)onSuccess
                            onFailure:(BSOnHTTPRequestFailure)onFailure {
    
    BSHTTPMultipartItem *uploadItem = [[BSHTTPMultipartItem alloc] init];
    NSData *imageData = UIImagePNGRepresentation(image);
    uploadItem.fileData = imageData;
    uploadItem.name = @"file";
    uploadItem.fileName = [NSString stringWithFormat:@"file%@",[imageData detectImageSuffix]];
    uploadItem.mimeType = @"multipart/form-data";
    [[BSNetworking sharedInstance] httpUploadMultipartData:@[uploadItem]
                                                 parameters:@{@"policy": policy,
                                                              @"signature": signature
                                                              }
                                          AbsoluteURLString:uploadURLString
                                                   progress:progress
                                                  onSuccess:onSuccess
                                                  onFailure:onFailure];
}

- (void)getBaiDuIndexPageOnSuccess:(BSOnHTTPRequestSuccess)onSuccess
                         onFailure:(BSOnHTTPRequestFailure)onFailure {
    [[BSNetworking sharedInstance] httpGetWithAbsoluteURL:@"http://www.baidu.com"
                                                   params:nil
                                                onSuccess:onSuccess
                                                onFailure:onFailure];
}

@end
