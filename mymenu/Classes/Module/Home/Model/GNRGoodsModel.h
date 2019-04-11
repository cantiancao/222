//
//  GNRGoodsModel.h
//  外卖
//
//  Created by LvYuan on 2017/5/2.
//  Copyright © 2017年 BattlePetal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GNRGoodsModel : NSObject

@property (nonatomic, strong)NSString * title;
@property (nonatomic, strong)NSString * profile;
@property (nonatomic, strong)NSString *content;
@property (nonatomic, strong)NSString * imgUr;
@property (nonatomic, strong)NSNumber *menuid;
@property (nonatomic, assign)float shouldPayMoney;
@property (nonatomic, strong)NSNumber * collectNum;//购买个数

@end
