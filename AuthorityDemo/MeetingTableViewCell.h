//
//  MeetingTableViewCell.h
//  AuthorityDemo
//
//  Created by 陈凯 on 2019/4/4.
//  Copyright © 2019 陈凯. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MeetingTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary * meetingInfo;

@property (nonatomic, strong) UIView * backView;

@property (nonatomic, strong) UILabel * nameLab;

@property (nonatomic, strong) UILabel * numLab;

@end

NS_ASSUME_NONNULL_END
