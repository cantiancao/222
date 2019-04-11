//
//  HCBaseViewController.m
//  eHomeMaster
//
//  Created by MAC mini on 2017/8/8.
//  Copyright © 2017年 YJLZ. All rights reserved.
//

#import "HCBaseViewController.h"
@interface HCBaseViewController ()

@end

@implementation HCBaseViewController
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //去掉返回按钮的文字
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
}
#pragma mark ---- 网络请求显示视图 ----
/* The image for the empty state */
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *imgName;
    if (self.error) {
        imgName = KBadNetworkImgName;
    } else {
        imgName = KLoadNetworkImgName;
    }
    return [UIImage imageNamed:imgName];
}
/* The attributed string for the description of the empty state */
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text;
    if (self.error) {
        text = KBadNetworkTip;
    } else {
        text = KLoadNetworkTip;
    }
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
/* The background color for the empty state */
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return kRGBColor(238, 238, 238); // redColor whiteColor
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return 30;
}
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    if (self.error) {
        return 0;
    } else {
        return -15;
    }
}

@end
