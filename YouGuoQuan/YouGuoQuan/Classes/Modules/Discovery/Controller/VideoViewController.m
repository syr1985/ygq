//
//  VideoViewController.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/10.
//  Copyright © 2016年 NT. All rights reserved.
//  

#import "VideoViewController.h"
#import "TrendsDetailViewController.h"
#import "DiscoveryVideoModel.h"
#import "HomeFocusModel.h"
#import "VideoViewCell.h"
#import "AlertViewTool.h"
#import <MJRefresh.h>

@interface VideoViewController ()
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, assign) int pageNo;
@property (nonatomic, assign) int pageSize;
@end

@implementation VideoViewController

static NSString * const collectionViewCellID = @"VideoViewCell";

#pragma mark -
#pragma mark - 懒加载
- (NSMutableArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

#pragma mark -
#pragma mark - 系统方法
- (void)dealloc {
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteTrendsSuccess:)
                                                 name:kNotification_DeleteTrendsSuccess
                                               object:nil];
    
    [self configViewController];
}

- (void)deleteTrendsSuccess:(NSNotification *)noti {
    NSString *trendsId = noti.userInfo[@"trendsId"];
    __weak typeof(self) weakself = self;
    [self.modelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DiscoveryVideoModel *model = (DiscoveryVideoModel *)obj;
        if ([model.videoId isEqualToString:trendsId]) {
            [weakself updateLocalData:idx];
            *stop = YES;
        }
    }];
}

- (void)updateLocalData:(NSInteger )row {
    [self.modelArray removeObjectAtIndex:row];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - 配置控制器
- (void)configViewController {
    self.pageNo = 1;
    self.pageSize = 10;
    
    // Register cell classes
    self.collectionView.backgroundColor = NavBackgroundColor;
    UINib *nib = [UINib nibWithNibName:collectionViewCellID bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:collectionViewCellID];
    
    // Do any additional setup after loading the view.
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                     refreshingAction:@selector(loadNewData)];
    
    // 设置文字
    [header setTitle:@"下拉刷新数据" forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    // 马上进入刷新状态
    [header beginRefreshing];
    // 设置刷新控件
    self.collectionView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self
                                                                             refreshingAction:@selector(loadMoreData)];
    // 设置文字
    [footer setTitle:@"上拉刷新数据" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载更多..." forState:MJRefreshStateRefreshing];
    //[footer setTitle:@"到底了" forState:MJRefreshStateNoMoreData];
    footer.automaticallyRefresh = NO;
    footer.hidden = YES;
    // 设置footer
    self.collectionView.mj_footer = footer;
}

#pragma mark -
#pragma mark - 加载数据
- (void)loadNewData {
    _pageNo = 1;
    [self loadDataFromServer];
}

- (void)loadMoreData {
    _pageNo++;
    [self loadDataFromServer];
}

#pragma mark -
#pragma mark - 从服务器加载数据
- (void)loadDataFromServer {
    __weak typeof(self) weakself = self;
    [NetworkTool getDiscoveryVideosListWithPageNo:@(_pageNo) pageSize:@(_pageSize) success:^(id result) {
        //NSLog(@"%@",result);
        NSMutableArray *muArray = [NSMutableArray array];
        for (NSDictionary *dict in result) {
            DiscoveryVideoModel *model = [DiscoveryVideoModel discoveryVideoModelWithDict:dict];
            [muArray addObject:model];
        }
        weakself.collectionView.mj_footer.hidden = muArray.count < weakself.pageSize;
        if (weakself.pageNo == 1) {
            [weakself.collectionView.mj_header endRefreshing];
            weakself.modelArray = muArray;
            [weakself.collectionView reloadData];
        } else {
            [weakself.collectionView.mj_footer endRefreshing];
            [weakself.modelArray addObjectsFromArray:muArray];
            [weakself.collectionView reloadData];
        }
    } failure:^{
        if (weakself.pageNo == 1) {
            [weakself.collectionView.mj_header endRefreshing];
        } else {
            [weakself.collectionView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark -
#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];
    
    // Configure the cell
    cell.discoveryVideoModel = self.modelArray[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat sizeW = (WIDTH - 19) * 0.5;
    return CGSizeMake(sizeW, sizeW);
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (![LoginData sharedLoginData].isRecommend) {
        if (indexPath.row > 11) {
            __weak typeof(self) weakself = self;
            [AlertViewTool showAlertViewWithTitle:nil Message:@"非会员用户只能观看部分视频资源，立即开通贵族会员，即可免费观看所有视频" cancelTitle:@"取消" sureTitle:@"确定" sureBlock:^{
                [weakself pushToYouGuoNobilityViewController];
            } cancelBlock:nil];
        } else {
            [self pushToDetailViewController:indexPath];
        }
    } else {
        [self pushToDetailViewController:indexPath];
    }
}

- (void)pushToYouGuoNobilityViewController {
    UIStoryboard *centerSB = [UIStoryboard storyboardWithName:@"Center" bundle:nil];
    UIViewController *nobilityVC = [centerSB instantiateViewControllerWithIdentifier:@"PayForNobilityVC"];
    nobilityVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nobilityVC animated:YES];
}

- (void)pushToDetailViewController:(NSIndexPath *)indexPath {
    if (![LoginData sharedLoginData].userId) {
        UIStoryboard *loginSB = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        UIViewController *loginVC = [loginSB instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self.navigationController presentViewController:loginVC animated:YES completion:nil];
        return;
    }
    
    DiscoveryVideoModel *model = self.modelArray[indexPath.row];
    HomeFocusModel *homeFocusModel = [[HomeFocusModel alloc] init];
    homeFocusModel.focusId             = model.videoId;
    homeFocusModel.videoEvelope        = model.videoEvelope;
    homeFocusModel.feedsType           = 2;
    homeFocusModel.nickName            = model.nickName;
    homeFocusModel.star                = model.star;
    // createTime 没传，格式不同
    
    UIStoryboard *focusSB = [UIStoryboard storyboardWithName:@"Focus" bundle:nil];
    TrendsDetailViewController *trendsDetailVC = [focusSB instantiateViewControllerWithIdentifier:@"TrendsDetailVC"];
    trendsDetailVC.hidesBottomBarWhenPushed = YES;
    trendsDetailVC.homeFocusModel = homeFocusModel;
    [self.navigationController pushViewController:trendsDetailVC animated:YES];
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
