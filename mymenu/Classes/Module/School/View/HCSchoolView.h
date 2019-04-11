//
//  HCSchoolView.h
//  mymenu
//
//  Created by zcp on 2018/8/27.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCSchoolView : UICollectionView
typedef void(^schoolcellBlock)(NSString *htmlstr);

@property (nonatomic, copy) schoolcellBlock schoolcellBlock;
/** 类型 **/
@property(nonatomic,assign) NSInteger h5Type;

+ (instancetype)getTabelViewWithType:(NSInteger)type frame:(CGRect)frame;
@end
