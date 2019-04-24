//
//  API.h
//  AuthorityDemo
//
//  Created by 陈凯 on 2019/4/2.
//  Copyright © 2019 陈凯. All rights reserved.
//

#ifndef API_h
#define API_h


//#define Host_URL                    @"http://192.168.0.31:8989/"
#define Host_URL                    @"https://sdk.chatboard.cn:8989/"




#define Login_URL                   [NSString stringWithFormat:@"%@Demo/user/login",Host_URL]

#define MeetingList_URL             [NSString stringWithFormat:@"%@Demo/meeting/getList",Host_URL]

#define Create_URL                  [NSString stringWithFormat:@"%@Demo/meeting/create",Host_URL]

#define MeetingInfo_URL             [NSString stringWithFormat:@"%@Demo/meeting/get",Host_URL]


#endif /* API_h */
