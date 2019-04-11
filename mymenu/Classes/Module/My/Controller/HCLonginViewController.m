//
//  HCLonginViewController.m
//  mymenu
//
//  Created by pconline on 2018/8/28.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import "HCLonginViewController.h"
#import "NSString+RegularExpression.h"
@interface HCLonginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextF;
@property (weak, nonatomic) IBOutlet UITextField *codeTextF;
@property (weak, nonatomic) IBOutlet UIButton *authCodeBtn;

@end

@implementation HCLonginViewController
- (IBAction)authCodeBtnAction:(UIButton *)sender {
    if (self.phoneNumTextF.text.length == 0) {
        [[HCHudTool sharedHUDTool] showProgressHUDInView:self.view tip:@"手机号码不能为空"];
        return;
    }
    
    if (![self checkPhoneNum]) {
        [[HCHudTool sharedHUDTool] showProgressHUDInView:self.view tip:@"请输入有效的手机号码"];
        return;
    }
    NSDictionary *param = @{@"mobile" : self.phoneNumTextF.text
                            };
    [[HCNetworkTool sharedNetworkTool] GETLoginWithUrlString:@"http://188z20966o.iok.la:41428/article/sendSms.htm" parameters:param successBlock:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *code = responseObject[@"code"];
        if ([code isEqualToString:@"0000"]) {
            
            [self openCountdown];
        }else{
            [[HCHudTool sharedHUDTool] showProgressHUDInView:self.view tip:@"验证码获取失败"];
        }
        
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
        [[HCHudTool sharedHUDTool] showProgressHUDInView:self.view tip:@"验证码获取失败"];
    }];
}
- (IBAction)loginBtnAction:(UIButton *)sender {
    if (self.phoneNumTextF.text.length == 0) {
        [[HCHudTool sharedHUDTool] showProgressHUDInView:self.view tip:@"手机号码不能为空"];
        return;
    }
    if (![self checkPhoneNum]) {
        [[HCHudTool sharedHUDTool] showProgressHUDInView:self.view tip:@"请输入有效的手机号码"];
        return;
    }
    if (self.codeTextF.text.length == 0) {
        [[HCHudTool sharedHUDTool] showProgressHUDInView:self.view tip:@"请输入验证码"];
        return;
    }
    NSDictionary *param = @{@"userName" : self.phoneNumTextF.text,
                            @"verifyCode" : self.codeTextF.text,
                            };
    [[HCHudTool sharedHUDTool]showProgressHUDInView:self.view tip:@"正在登录"];
    [[HCNetworkTool sharedNetworkTool] GETLoginWithUrlString:@"http://188z20966o.iok.la:41428/article/login.htm" parameters:param successBlock:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *code = responseObject[@"code"];
        if ([code isEqualToString:@"0000"]) {
            //            [[HCHudTool sharedHUDTool] hide];
            [[HCHudTool sharedHUDTool] showProgressHUDInView:self.view tip:@"登录成功"];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"token"] forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"userName"] forKey:@"userName"];
            //            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"Name"] forKey:@"Name"];
            [self.navigationController popToRootViewControllerAnimated:YES];
            //            [self.navigationController pushViewController:[HCLoginController new] animated:YES];
        }else{
            //            [[HCHudTool sharedHUDTool] hide];
            [[HCHudTool sharedHUDTool] showProgressHUDInView:self.view tip:@"登录失败"];
        }
        
        
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error%@",error);
        [[HCHudTool sharedHUDTool] hide];
        [[HCHudTool sharedHUDTool] showProgressHUDInView:self.view tip:@"登录失败"];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登录";
        [self.phoneNumTextF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

//UITextField文字输入变化时通知执行方法
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.phoneNumTextF) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }

}
//是否有空格
-(BOOL)isEmpty:(NSString *) str {
    
    NSRange range = [str rangeOfString:@" "];
    if (range.location != NSNotFound) {
        return YES; //yes代表包含空格
    }else {
        return NO; //反之
    }
}
//根据正则，过滤特殊字符
- (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr{
    NSString *searchText = string;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, searchText.length) withTemplate:@""];
    return result;
}
//电话号校验
- (BOOL)checkPhoneNum {
    NSString *pattern = KPattern;
    NSString *strUrl = [self.phoneNumTextF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *result = [strUrl firstMatchStringWithPattern:pattern];
    if (result == nil) {
        return NO;
    } else{
        return YES;
    }
}
//验证码倒计时
-(void)openCountdown{
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
                [self.authCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.authCodeBtn setBackgroundColor:[UIColor redColor]];
                self.authCodeBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                [self.authCodeBtn setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                [self.authCodeBtn setBackgroundColor:[UIColor lightGrayColor]];
                self.authCodeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

@end
