//
//  HCFeedbackViewController.m
//  mymenu
//
//  Created by pconline on 2018/8/28.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import "HCFeedbackViewController.h"

@interface HCFeedbackViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *messageT;
@property (weak, nonatomic) IBOutlet UILabel *placeL;

@end

@implementation HCFeedbackViewController
- (IBAction)btnAction:(UIButton *)sender {
    [[HCHudTool sharedHUDTool] showProgressHUDInView:self.view tip:@"提交中"];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [[HCHudTool sharedHUDTool] hide];
        [[HCHudTool sharedHUDTool] showProgressHUDInView:self.view tip:@"提交成功"];
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"意见反馈";
    self.messageT.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textViewDidChange:(UITextView *)textView{

    if (textView.text.length > 0) {
        self.placeL.hidden = YES;
    }else{
        self.placeL.hidden = NO;
    }
    if (textView.text.length>80) {
        textView.text = [textView.text substringToIndex:80];
        //    [PCPromptView showText:@"只能输入10个字哦"];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
