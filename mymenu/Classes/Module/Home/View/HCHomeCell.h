//
//  HCHomeCell.h
//  mymenu
//
//  Created by zcp on 2018/8/27.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCHomeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picimg;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *descL;
@property (weak, nonatomic) IBOutlet UILabel *countL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *HandW;

@end
