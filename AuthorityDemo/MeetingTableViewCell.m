//
//  MeetingTableViewCell.m
//  AuthorityDemo
//
//  Created by 陈凯 on 2019/4/4.
//  Copyright © 2019 陈凯. All rights reserved.
//

#import "MeetingTableViewCell.h"

@implementation MeetingTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor=[UIColor clearColor];
        
        self.backgroundView=nil;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        _backView = [[UIView alloc]initWithFrame:CGRectMake(15, 20, [UIScreen mainScreen].bounds.size.width-25, 110)];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = 5;
        _backView.clipsToBounds = YES;
        _backView.userInteractionEnabled = YES;
        _backView.layer.borderColor = [UIColor blueColor].CGColor;
        _backView.layer.borderWidth = 0.5;
        [self.contentView addSubview:_backView];
        
        _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, _backView.frame.size.width, 50)];
        _nameLab.textColor = [UIColor blackColor];
        _nameLab.userInteractionEnabled = YES;
        _nameLab.font = [UIFont systemFontOfSize:18];
        [_backView addSubview:_nameLab];
        
        _numLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 60, _nameLab.frame.size.width, 50)];
        _numLab.textColor = [UIColor grayColor];
        _numLab.userInteractionEnabled = YES;
        _numLab.font = [UIFont systemFontOfSize:16];
        [_backView addSubview:_numLab];
    }
    return self;
}

-(void)setMeetingInfo:(NSDictionary *)meetingInfo
{
    _meetingInfo = meetingInfo;
    
    _nameLab.text = [meetingInfo objectForKey:@"name"];
    
    NSString * numStr = [NSString stringWithFormat:@"会议邀请码：%@",[meetingInfo objectForKey:@"meetingNum"]];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:numStr];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:[numStr rangeOfString:[NSString stringWithFormat:@"%@",[meetingInfo objectForKey:@"meetingNum"]]]]; //设置字体颜色
    
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:25] range:[numStr rangeOfString:[NSString stringWithFormat:@"%@",[meetingInfo objectForKey:@"meetingNum"]]]]; //设置字体字号和字体类别
    
    _numLab.attributedText = str;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
