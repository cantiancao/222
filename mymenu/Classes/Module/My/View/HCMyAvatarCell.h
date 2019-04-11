//
//  HCMyAvatarCell.h
//  eHomeClient
//
//  Created by MAC mini on 2017/3/14.
//  Copyright © 2017年 YJLZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCMyAvatarCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *avatarBtn;
@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *numL;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end
