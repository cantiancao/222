//
//  HCMySetupViewController.m
//  mymenu
//
//  Created by zcp on 2018/8/28.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import "HCMySetupViewController.h"

@interface HCMySetupViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *picimg;
@property (weak, nonatomic) IBOutlet UITextView *messageT;
@property (weak, nonatomic) IBOutlet UILabel *placeL;
@property (strong, nonatomic)UIImage *img;
@end

@implementation HCMySetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人设置";
    self.messageT.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)picBtnAction:(UIButton *)sender {
    [self getImage];
}

- (void)saveImage:(UIImage *)image {
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    
    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"demo.png"]];  // 保存文件的名称
    
    BOOL result =[UIImagePNGRepresentation(image)writeToFile:filePath   atomically:YES]; // 保存成功会返回YES
    if (result == YES) {
        NSLog(@"保存成功");
    }
    
}
- (IBAction)commitBtnAction:(UIButton *)sender {
    [[HCHudTool sharedHUDTool] showProgressHUDInView:self.view tip:@"提交中"];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    [self saveImage:self.img];
    [[NSUserDefaults standardUserDefaults] setObject:self.messageT.text forKey:@"message"];
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [[HCHudTool sharedHUDTool] hide];
        [self.navigationController popViewControllerAnimated:YES];
    });
}
- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length > 0) {
        self.placeL.hidden = YES;
    }else{
        self.placeL.hidden = NO;
    }
    if (textView.text.length>20) {
        textView.text = [textView.text substringToIndex:20];
        //    [PCPromptView showText:@"只能输入10个字哦"];
    }
}
//弹出相册
- (void)getImage {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;
        picker.allowsEditing = YES;//设置可编辑
        //        picker.showsCameraControls = NO;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];//进入照相界面
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;
        picker.allowsEditing = YES;//设置可编辑
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];//进入照相界面
    }];
    [alertView addAction:action3];
    [alertView addAction:action2];
    [alertView addAction:action];
    [self presentViewController:alertView animated:YES completion:nil];
}
//头像上传
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self.picimg setImage:image];
    self.img = image;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
@end
