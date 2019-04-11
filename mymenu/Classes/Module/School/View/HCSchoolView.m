//
//  HCSchoolView.m
//  mymenu
//
//  Created by zcp on 2018/8/27.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import "HCSchoolView.h"
#import "HCSchoolCell.h"
#import "UIScrollView+MJRefresh.h"
#import "MJRefresh.h"
@interface HCSchoolView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) int pageNo;///页数
@end
@implementation HCSchoolView

+ (instancetype)getTabelViewWithType:(NSInteger)type frame:(CGRect)frame{
        
    //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    HCSchoolView *collectionView=[[HCSchoolView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    collectionView.h5Type = type;
    [collectionView setBackgroundColor:[UIColor clearColor]];
    //注册Cell，必须要有
    [collectionView registerNib:[UINib nibWithNibName:@"HCSchoolCell" bundle:nil] forCellWithReuseIdentifier:@"HCSchoolCell"];
    [collectionView setup];
    [collectionView setUpRefresh];
    return collectionView;
    
}
-(NSMutableArray*)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(void)dealloc{
    self.delegate = nil;
    self.dataSource = nil;
}
- (void)setup{
    self.dataSource=self;
    self.delegate=self;
}
-(void)setUpRefresh{

    __weak typeof(self) wself = self;
//    self.mj_header = [MJRefreshHeader headerWithRefrshBlock:^{
//        [wself refresh];
//    }];
    self.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [wself refresh];
    }];
   
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [wself loadMore];
    }];
     [self.mj_header beginRefreshing];
}

-(void)refresh{
    self.pageNo = 1;
    [self.dataArray removeAllObjects];
//    [self.mj_footer resetNoMoreData];
    [self getData];
}

-(void)loadMore{
//     [self.mj_footer resetNoMoreData];
    [self getData];
}
- (void)getData{
    NSDictionary *param = @{
                            @"pageIndex" : [NSString stringWithFormat:@"%d",self.pageNo],
                            @"pageSize" : @"10",
                            @"id":@(self.h5Type)
                            };
    [[HCNetworkTool sharedNetworkTool] POSTLoginWithUrlString:@"http://188z20966o.iok.la:41428/article/infoList.htm" parameters:param successBlock:^(NSURLSessionDataTask *task, id responseObject) {
        [self.mj_footer endRefreshing];
        [self.mj_header endRefreshing];
        NSLog(@"%@",responseObject);
        ++self.pageNo;
        NSArray *tempArr = responseObject;
        [self.dataArray addObjectsFromArray:[tempArr copy]];
        //        if (self.dataList.count == 0) {
        //            [self.tableView removeFromSuperview];
        //            [self.emptyView showInView:self.view WithTitle:@"" secondTitle:@"暂时没有合作商家" iconname:@"home_img_picture2"];
        //        }else{
        //            [self.emptyView removeFromSuperview];
        //        }
        //停止刷新
        if (tempArr.count == 0) {
            self.mj_footer.state = MJRefreshStateNoMoreData;
        }
        [self reloadData];
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
        //请求错误回调
    }];
    
}
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"HCSchoolCell";
    HCSchoolCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"HCSchoolCell" owner:nil options:nil] lastObject];
    }
    NSDictionary *dict = [NSDictionary changeType:self.dataArray[indexPath.row]];
    NSArray *imgs= dict[@"imgUrlList"];
    if (imgs.count >0) {
        [cell.picImg sd_setImageWithURL:[NSURL URLWithString:imgs[0]] placeholderImage:nil];
    }
    cell.descL.text = dict[@"title"];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [NSDictionary changeType:self.dataArray[indexPath.row]];
    if (self.schoolcellBlock) {
        self.schoolcellBlock(dict[@"content"]);
    }
    NSDictionary *param = @{
                            @"userName" : [[NSUserDefaults standardUserDefaults] stringForKey:@"userName"]?[[NSUserDefaults standardUserDefaults] stringForKey:@"userName"]:@"",
                            @"token" : [[NSUserDefaults standardUserDefaults] stringForKey:@"token"]?[[NSUserDefaults standardUserDefaults] stringForKey:@"token"]:@"",
                            @"id" : dict[@"id"]?dict[@"id"]:@""
                            };
    [[HCNetworkTool sharedNetworkTool] POSTLoginWithUrlString:@"http://188z20966o.iok.la:41428/article/articleDetail.htm" parameters:param successBlock:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenWidth-30)/2.0, (kScreenWidth-30)*0.8/2.0);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


@end
