//
//  NetWorkingManager.h
//  MeetingGroup
//
//  Created by zzx on 17/9/5.
//  Copyright © 2017年 陈凯. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface NetWorkingManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

- (void)requestUpdateIosPnsToken:(NSString *)token;

@end
