//
//  NetWorkingManager.m
//  MeetingGroup
//
//  Created by zzx on 17/9/5.
//  Copyright © 2017年 陈凯. All rights reserved.
//

#import "NetWorkingManager.h"

@implementation NetWorkingManager

+ (instancetype)sharedManager {
    
    static NetWorkingManager *sharedManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[NetWorkingManager alloc] initWithBaseURL:nil];
        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        policy.allowInvalidCertificates = YES;//HTTPS不允许无效的证书
        policy.validatesDomainName = NO;//HTTPS验证证书的域名
        sharedManager.securityPolicy = policy;
//        sharedManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript",@"text/plain",nil];
        [sharedManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        sharedManager.responseSerializer.acceptableContentTypes=[NSSet setWithArray:@[@"application/json",
                                                                                      @"application/x-javascript",
                                                                                      @"text/html",
                                                                                      @"text/json",
                                                                                      @"text/plain",
                                                                                      @"text/javascript",
                                                                                      @"text/xml",
                                                                                      @"image/*"]];
    });
    
    return sharedManager;
    
}

@end
