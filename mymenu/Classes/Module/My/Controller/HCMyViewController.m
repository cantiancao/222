//
//  HCMyViewController.m
//  eHomeClient
//
//  Created by MAC mini on 2017/3/14.
//  Copyright © 2017年 YJLZ. All rights reserved.
//

#import "HCMyViewController.h"
#import "HCMyAvatarCell.h"
#import "HCNetworkTool.h"
#import "HCHudTool.h"
#import "UIButton+WebCache.h"
#import "HCFeedbackViewController.h"
#import "HCLonginViewController.h"
#import "HCMyrecordViewController.h"
#import "HCMycollectViewController.h"
#import "HCMySetupViewController.h"
@interface HCMyViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak,nonatomic)UITableView *tableView;
@property (weak,nonatomic)UIView *firstcellBgView;
@property (strong,nonatomic)UIButton *outbtn;
@end

@implementation HCMyViewController
-(void)dealloc {
     [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.tableView reloadData];
    if ([[NSUserDefaults standardUserDefaults]stringForKey:@"token"]) {
        self.outbtn.hidden = NO;
    } else {
        self.outbtn.hidden = YES;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航控制器的代理为self
    self.navigationItem.title = @"我的";
    self.navigationController.delegate = self;
    [self initUI];
    //监听tableView的contentOffset变化
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionInitial context:nil];
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        // 处理顶部头像
        CGFloat scale = self.tableView.contentOffset.y / 200;
        if (self.tableView.contentOffset.y<0) {
            self.firstcellBgView.transform = CGAffineTransformMakeScale(1 - scale, 1 - scale);
             CGRect frame = self.firstcellBgView.frame;
            frame.origin.y = scale*225;
            self.firstcellBgView.frame = frame;
        }
    }
}
#pragma mark - 私有方法
- (void)initUI {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -(KNaviBarHeight-44), kScreenWidth, kScreenHeight)];
    self.tableView =tableView;
    tableView.backgroundColor = UIColorHex(@"#eeeeee");
    self.tableView.showsVerticalScrollIndicator =NO;
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    tableView.delegate = self;
    //没有数据cell的遮盖
    UIView *zheZhaoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
    zheZhaoView.backgroundColor = UIColorHex(@"#eeeeee");
    UIButton *outbtn = [[UIButton alloc]initWithFrame:CGRectMake(40, 40,kScreenWidth -80, 44)];
    self.outbtn = outbtn;
    outbtn.layer.cornerRadius = 3;
    outbtn.layer.masksToBounds = YES;
    [outbtn setTitle:@"安全退出" forState:UIControlStateNormal];
    [outbtn setTintColor:[UIColor whiteColor]];
    [outbtn setBackgroundColor:UIColorHex(@"e54017")];
    [outbtn addTarget:self action:@selector(outbtnAction) forControlEvents:UIControlEventTouchUpInside];
    [zheZhaoView addSubview:outbtn];
    tableView.tableFooterView = zheZhaoView;
}
- (IBAction)avatarBtnDidClick {
//    if ([HCUserViewModel sharedUserViewModel].isLogin) {
//        [self getImage];
//    }else{
//        [[HCHudTool sharedHUDTool] showProgressHUDInView:self.view tip:@"请先登录"];
//    }
}
- (IBAction)loginBtnDidClick {
    [self.navigationController pushViewController:[HCLonginViewController new] animated:YES];
}
-(void)outbtnAction{
    [[HCHudTool sharedHUDTool] showProgressHUDInView:self.view tip:@"安全退出中"];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [[HCHudTool sharedHUDTool] hide];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userName"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"token"];
        [self.tableView reloadData];
        if ([[NSUserDefaults standardUserDefaults]stringForKey:@"token"]) {
            self.outbtn.hidden = NO;
        } else {
            self.outbtn.hidden = YES;
        }
    });
    
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
////图片压缩
- (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
//头像上传
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
    NSDictionary *param = @{@"Mobileno" : KMobileno,
                            @"Token" : KToken,
                            @"Reqtime":KTimestamp,
                            @"Usertype":KUsertype
                            };
    NSData *data = UIImageJPEGRepresentation([self imageWithImage:image scaledToSize:CGSizeMake(200, 200)], 0.5);
    __weak typeof(self) weakSelf = self;
    [[HCNetworkTool sharedNetworkTool].afn POST:[NSString stringWithFormat:@"%@user/uploadimage",URL_MAIN] parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:data name:@"File" fileName:fileName mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"上传进度-----   %@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"image上传成功 %@",responseObject);
//        [HCUserViewModel sharedUserViewModel].userModel.Image = responseObject[@"url"];
        [[HCHudTool sharedHUDTool] showProgressHUDInView:self.view tip:@"头像上传成功"];
        [weakSelf.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[HCHudTool sharedHUDTool] showProgressHUDInView:self.view tip:@"头像上传失败"];
    }];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
#pragma tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"mycell";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    if (indexPath.row == 0) {
        HCMyAvatarCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"HCMyAvatarCell" owner:nil options:nil] lastObject];
        [cell.avatarBtn addTarget:self action:@selector(avatarBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.loginBtn addTarget:self action:@selector(loginBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        cell.avatarBtn.layer.cornerRadius = 50;
        cell.avatarBtn.layer.masksToBounds =YES;
        
        if ([[NSUserDefaults standardUserDefaults]stringForKey:@"token"]) {
            cell.messageView.hidden = NO;
            cell.loginBtn.hidden = YES;
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            
            NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:
                                  [NSString stringWithFormat:@"demo.png"]];
            // 保存文件的名称
            UIImage *img = [UIImage imageWithContentsOfFile:filePath];

            if (img) {
                [cell.avatarBtn setImage:img forState:UIControlStateNormal];
//                cell.avatarBtn.imageView.image = img;
            } else {
               [cell.avatarBtn setImage:[UIImage imageNamed:@"tx"] forState:UIControlStateNormal];
            }
            cell.numL.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"message"]?[[NSUserDefaults standardUserDefaults] stringForKey:@"message"]:@"（厨神驾到,打造健康饮食理念！）";
            cell.nameL.text = @"初入厨界";
//            cell.numL.text = KMobileno;
//            [cell.avatarBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_IMG,[HCUserViewModel sharedUserViewModel].userModel.Image]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"tx"]];
        }else{

            cell.messageView.hidden = YES;
            cell.loginBtn.hidden = NO;
        }
        self.firstcellBgView = cell.bgView;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"我的收藏";
        cell.imageView.image = [UIImage imageNamed:@"矩形 1 拷贝1"];
    }
    else if (indexPath.row == 2){
        cell.textLabel.text = @"浏览记录";
        cell.imageView.image = [UIImage imageNamed:@"矩形 1 拷贝4"];
    }
    else if (indexPath.row == 3){
        cell.textLabel.text = @"意见反馈";
        cell.imageView.image = [UIImage imageNamed:@"矩形 1 拷贝3"];
    }
    else if (indexPath.row == 4){
        cell.textLabel.text = @"个人设置";
        cell.imageView.image = [UIImage imageNamed:@"图层 0 拷贝"];
    }
    else if (indexPath.row == 5){
        cell.textLabel.text = @"V1.0.0";
        cell.imageView.image = [UIImage imageNamed:@"矩形 1 拷贝2"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1 ) {
        if ([[NSUserDefaults standardUserDefaults]stringForKey:@"token"]) {
            [self.navigationController pushViewController:[HCMycollectViewController new] animated:YES];
        } else {
            [[HCHudTool sharedHUDTool] showProgressHUDInView:self.view tip:@"请先登录"];
        }
    }
    if (indexPath.row == 2 ) {
        if ([[NSUserDefaults standardUserDefaults]stringForKey:@"token"]) {
            [self.navigationController pushViewController:[HCMyrecordViewController new] animated:YES];
        } else {
            [[HCHudTool sharedHUDTool] showProgressHUDInView:self.view tip:@"请先登录"];
        }
    }
    if (indexPath.row == 3 ) {
        [self.navigationController pushViewController:[HCFeedbackViewController new] animated:YES];
    }
    if (indexPath.row == 4 ) {
        if ([[NSUserDefaults standardUserDefaults]stringForKey:@"token"]) {
            [self.navigationController pushViewController:[HCMySetupViewController new] animated:YES];
        } else {
            [[HCHudTool sharedHUDTool] showProgressHUDInView:self.view tip:@"请先登录"];
        }
    }
}
#pragma TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 230;
    } else {
        return 44;
    }
}
@end
