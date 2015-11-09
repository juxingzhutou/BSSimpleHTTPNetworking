//
//  ViewController.m
//  BSSimpleHTTPNetworkingDemo
//
//  Created by juxingzhutou on 15/11/6.
//  Copyright © 2015年 bluntsword. All rights reserved.
//

#import "ViewController.h"
#import "BSHTTPAPI.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.httpGetMethodTestButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    NSString *buttonTitle = @"获取百度首页\nHTTP Get Method";
    self.httpGetMethodTestButton.titleLabel.text = buttonTitle;
    [self.httpGetMethodTestButton setTitle:buttonTitle forState:UIControlStateNormal];
}

- (IBAction)getBaiDuIndexPage:(id)sender {
    BSOnHTTPRequestSuccess onSuccess = ^(id res) {
        NSLog(@"Success:%@", [[NSString alloc] initWithData:res encoding:NSUTF8StringEncoding]);
    };
    
    BSOnHTTPRequestFailure onFailure = ^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        NSLog(@"Failure:%@", error);
    };
    
    [[BSHTTPAPI sharedInstance] getBaiDuIndexPageOnSuccess:onSuccess onFailure:onFailure];
}

@end
