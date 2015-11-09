//
//  BSHTTPAPI.h
//  WoDong
//
//  Created by juxingzhutou on 15/7/15.
//  Copyright (c) 2015年 renhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTTPApiMacro.h"
#import "BSNetworking.h"

@interface BSHTTPAPI : NSObject

+ (instancetype)sharedInstance;

- (void)uploadImageToUpYunWithUIImage:(UIImage *)image
                            uploadURL:(NSString *)uploadURLString
                               policy:(NSString *)policy
                            signature:(NSString *)signature
                             progress:(NSProgress *__autoreleasing *)progress
                            onSuccess:(BSOnHTTPRequestSuccess)onSuccess
                            onFailure:(BSOnHTTPRequestFailure)onFailure;

- (void)getBaiDuIndexPageOnSuccess:(BSOnHTTPRequestSuccess)onSuccess
                         onFailure:(BSOnHTTPRequestFailure)onFailure;

@end
