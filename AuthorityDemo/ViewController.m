//
//  ViewController.m
//  AuthorityDemo
//
//  Created by 陈凯 on 2019/4/2.
//  Copyright © 2019 陈凯. All rights reserved.
//

#import "ViewController.h"
#import "NetWorkingManager.h"
#import "API.h"
#import "MeetingTableViewCell.h"
#import <FlutterPluginRegistrant/GeneratedPluginRegistrant.h>
#import <Flutter/Flutter.h>
#import "SecondViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSDictionary * userInfo;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"权限DEMO";
    
    self.view.backgroundColor = [UIColor colorWithRed:235/255. green:235/255. blue:235/255. alpha:1];
    
//    self.navigationController.navigationBarHidden = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createMeeting)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(tapSearchInviteCode)];
    
    _userInfo = [NSDictionary dictionary];
    
    _dataSource = [NSMutableArray array];
    
    _userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    
    __weak ViewController * weakSelf = self;
    
    [[NetWorkingManager sharedManager] POST:Login_URL
                                 parameters:_userInfo ? @{@"userId":[_userInfo objectForKey:@"userId"]} : nil
                                   progress:^(NSProgress * _Nonnull uploadProgress) {}
                                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
        
        NSLog(@"responseObject    Login    %@",responseObject);
        
        if([[responseObject objectForKey:@"state"] integerValue] == 1)
        {
            weakSelf.userInfo = [responseObject objectForKey:@"result"];
            
            [[NSUserDefaults standardUserDefaults] setObject:weakSelf.userInfo forKey:@"userInfo"];
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:@"获取用户信息失败" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                NSLog(@"点击取消");
                
            }]];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
        
    }
                                    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        
        NSLog(@"error    %@",error);
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:[NSString stringWithFormat:@"%@",error] preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"点击取消");
            
        }]];
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    }];
    
    [self createSubviews];
}

-(void)viewWillAppear:(BOOL)animated
{
    if(_userInfo)
    {
        [self getMyMeetingList];
    }
}

-(void)getMyMeetingList
{
    __weak ViewController * weakSelf = self;
    
    [[NetWorkingManager sharedManager] GET:MeetingList_URL parameters:@{@"userId":[_userInfo objectForKey:@"userId"]} progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject    meetinglist    %@",responseObject);
        
        if([[responseObject objectForKey:@"state"] integerValue] == 1)
        {
            weakSelf.dataSource = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"result"]];
            
            [weakSelf.tableView reloadData];
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:@"获取会议列表失败" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                NSLog(@"点击取消");
                
            }]];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error    %@",error);
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:[NSString stringWithFormat:@"%@",error] preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"点击取消");
            
        }]];
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    }];
}

-(void)createSubviews
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width - [[UIApplication sharedApplication] statusBarFrame].size.height - [[UINavigationController alloc]init].navigationBar.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.backgroundView=nil;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

-(void)tapSearchInviteCode
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入会议邀请码,加入会议" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"请输入会议邀请码";
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"请输入角色ID";
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UITextField *num = alertController.textFields.firstObject;
        UITextField *role = alertController.textFields.lastObject;
        
        [self getMeetingInfoByInviteCode:num.text andRole:role.text];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)getMeetingInfoByInviteCode:(NSString *)code andRole:(NSString *)role
{
    [self tapBackGroundView];
    
    __weak ViewController * weakSelf = self;
    
    [[NetWorkingManager sharedManager] GET:MeetingInfo_URL parameters:@{@"meetingNum":code,@"userId":[_userInfo objectForKey:@"userId"]} progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject    meetingInfo    %@",responseObject);
        
        if([[responseObject objectForKey:@"state"] integerValue] == 1)
        {
            NSDictionary * dic = [responseObject objectForKey:@"result"];
            NSDictionary * params = @{@"roomId":[dic objectForKey:@"meetingId"],
                                      @"roleId":role.length == 0 ? @([[dic objectForKey:@"roleId"] integerValue]) : @([role integerValue]),
                                      @"userId":[weakSelf.userInfo objectForKey:@"userId"],
                                      @"nickname":[weakSelf.userInfo objectForKey:@"nickName"],
                                      @"avatar":[weakSelf.userInfo objectForKey:@"headPic"],
                                      @"password":@""};
            
            [weakSelf joinMeetingWithParams:[weakSelf convertToJsonData:params]];
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:@"获取会议信息失败" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                NSLog(@"点击取消");
                
            }]];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"create error    %@",error);
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:[NSString stringWithFormat:@"%@",error] preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"点击取消");
            
        }]];
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MeetingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell)
    {
        cell = [[MeetingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if(_dataSource.count > indexPath.row)
    {
        cell.meetingInfo = [_dataSource objectAtIndex:indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_dataSource.count > indexPath.row)
    {
        NSDictionary * dic = [_dataSource objectAtIndex:indexPath.row];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入角色ID，默认为1" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
            textField.placeholder = @"请输入角色ID";
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            UITextField *role = alertController.textFields.firstObject;
            
            NSDictionary * params = @{@"roomId":[dic objectForKey:@"meetingId"],@"roleId":role.text.length == 0 ? @1 : [NSNumber numberWithInt:[role.text intValue]],@"userId":[self.userInfo objectForKey:@"userId"],@"nickname":[self.userInfo objectForKey:@"nickName"],@"avatar":[self.userInfo objectForKey:@"headPic"],@"password":@""};
            
            [self joinMeetingWithParams:[self convertToJsonData:params]];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

-(void)joinMeetingWithParams:(NSString *)str
{
    NSLog(@"params   str    %@",str);
    SecondViewController* flutterViewController = [[SecondViewController alloc] init];
    [flutterViewController setInitialRoute:str];
    [GeneratedPluginRegistrant registerWithRegistry:flutterViewController];
    [self.navigationController pushViewController:flutterViewController animated:NO];
}

-(void)createMeeting
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入会议名称" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"请输入会议名称";
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UITextField *name = alertController.textFields.firstObject;
        
        [self createRequest:name.text];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)createRequest:(NSString *)name
{
    [self tapBackGroundView];
    
    __weak ViewController * weakSelf = self;
    
    [[NetWorkingManager sharedManager] POST:Create_URL
                                 parameters:@{@"name":name,@"userId":[_userInfo objectForKey:@"userId"]}
                                   progress:^(NSProgress * _Nonnull uploadProgress) {}
                                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSLog(@"responseObject    create    %@",responseObject);
         
         if([[responseObject objectForKey:@"state"] integerValue] == 1)
         {
             [weakSelf.dataSource addObject:[responseObject objectForKey:@"result"]];
             
             [weakSelf.tableView reloadData];
         }
         else
         {
             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:@"创建会议失败" preferredStyle:UIAlertControllerStyleAlert];
             [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                 
                 NSLog(@"点击取消");
                 
             }]];
             [weakSelf presentViewController:alertController animated:YES completion:nil];
         }
         
     }
                                    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         
         NSLog(@"create error    %@",error);
         
         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:[NSString stringWithFormat:@"%@",error] preferredStyle:UIAlertControllerStyleAlert];
         [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
             
             NSLog(@"点击取消");
             
         }]];
         [weakSelf presentViewController:alertController animated:YES completion:nil];
     }];
}

-(void)tapBackGroundView
{
    [self.view endEditing:YES];
}

-(NSString *)convertToJsonData:(id)dict
{
    NSError *error;
    
    NSData *jsonData = nil;
    
    if([dict isKindOfClass:[NSString class]])
    {
        jsonData=[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    }
    else
    {
        jsonData=[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    }
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    //    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    //    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}

@end
