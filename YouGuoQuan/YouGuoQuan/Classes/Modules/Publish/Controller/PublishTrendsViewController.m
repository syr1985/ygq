//
//  PublishTrendsViewController.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/28.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "PublishTrendsViewController.h"
#import "PublishTrendsHeaderView.h"
#import "PublishProductFooterView.h"
#import "ProductPhotoViewCell.h"

#import "TakePhotoHelp.h"
#import "AlertViewTool.h"
#import "UploadImageTool.h"
#import "NSString+Random.h"

@interface PublishTrendsViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *publishButton;
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *photoArray;
@property (nonatomic,   copy) NSString       *photosSize;
@property (nonatomic,   copy) NSString       *trendsContent;
@property (nonatomic, assign) BOOL           isUploadOrignalPhoto;

@end

static NSString * const collectionViewCellID_Header = @"PublishTrendsHeaderView";
static NSString * const collectionViewCellID_Footer = @"PublishProductFooterView";
static NSString * const collectionViewCellID_Photo  = @"ProductPhotoViewCell";

@implementation PublishTrendsViewController

#pragma mark -
#pragma mark - 懒加载
- (NSMutableArray<NSDictionary *> *)photoArray {
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
        [_photoArray addObject:@{@"image":[UIImage imageNamed:@"发布-添加"],@"url":@"",@"name":@""}];
    }
    return _photoArray;
}

#pragma mark -
#pragma mark - 系统方法
- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BackgroundColor;
    
    self.navigationController.navigationBar.tintColor = FontColor;
    self.navigationController.navigationBar.barTintColor = NavBackgroundColor;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FontColor,NSForegroundColorAttributeName,nil]];
    
    UICollectionViewFlowLayout *flowLaout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLaout.minimumLineSpacing = 3;
    flowLaout.minimumInteritemSpacing = 3;
    flowLaout.sectionInset = UIEdgeInsetsMake(12, 12, 12, 9);
    CGFloat itemW = (WIDTH - 27) / 3;
    flowLaout.itemSize = CGSizeMake(itemW, itemW);;
    flowLaout.headerReferenceSize = CGSizeMake(WIDTH, 150);
    flowLaout.footerReferenceSize = CGSizeMake(WIDTH, 30);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![LoginData sharedLoginData].userId) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"%s",__func__);
}

#pragma mark -
#pragma mark - 关闭页面
- (IBAction)dismissViewController {
    __weak typeof(self) weakself = self;
    [AlertViewTool showAlertViewWithTitle:nil
                                  Message:@"您确认放弃此次操作吗？"
                              cancelTitle:@"取消"
                                sureTitle:@"确定"
                                sureBlock:^{
                                    [weakself dismissViewControllerAnimated:YES completion:nil];
                                } cancelBlock:nil];
}

- (IBAction)publishTrends:(UIButton *)sender {
    if (!self.trendsContent || !self.trendsContent.length) {
        [SVProgressHUD showInfoWithStatus:@"请输入文字描述"];
        return;
    }
    
    sender.enabled = NO;
    [SVProgressHUD showWithStatus:@"发布图文动态"];
    __weak typeof(self) weakself = self;
    if (self.photoArray.count > 1) {
        NSMutableArray *muArray = [NSMutableArray array];
        for (NSUInteger i = 0 ; i < self.photoArray.count - 1; i++) {
            NSDictionary *dict = self.photoArray[i];
            UIImage *image = [dict objectForKey:@"image"];
            NSData *imageData = nil;
            if (_isUploadOrignalPhoto) {
                imageData = UIImageJPEGRepresentation(image,1);
            } else {
                imageData = UIImageJPEGRepresentation(image,0.75);
            }
            if (imageData) {
                [muArray addObject:imageData];
            }
        }
        [NetworkTool uploadImages:muArray
                         progress:nil
                          success:^(NSArray *urlArray) {
                              __strong typeof(self) strongself = weakself;
                              [strongself pornImageWithUrls:urlArray];
                          } failure:^{
                              __strong typeof(self) strongself = weakself;
                              [strongself publishFailure];
                          }];

//        NSArray *imageArray = [self.photoArray subarrayWithRange:(NSRange){0, self.photoArray.count - 1}];
//        [UploadImageTool pornImageWithImages:imageArray orignal:_isUploadOrignalPhoto success:^(NSArray *urlArray) {
//            [self pornImageWithUrls:urlArray];
//        } failure:^(NSMutableArray<NSDictionary *> *newImageArray, NSArray *sexImageArray) {
//            if (newImageArray) { // 上传图片失败
//                self.publishButton.enabled = YES;
//                [SVProgressHUD dismiss];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [SVProgressHUD showErrorWithStatus:@"图片上传失败，请重新发布"];
//                    [newImageArray addObject:[self.photoArray lastObject]];
//                    self.photoArray = [newImageArray mutableCopy];
//                });
//            } else {
//                if (sexImageArray) {
//                    [self tipsUserHasSexImage:sexImageArray];
//                } else {
//                    [SVProgressHUD dismiss];
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        self.publishButton.enabled = YES;
//                        [SVProgressHUD showErrorWithStatus:@"图片鉴黄失败，请重新发布"];
//                    });
//                }
//            }
//        }];
    } else {
        [self publishTrendsWithImageUrl:@""];
    }
}

//- (void)tipsUserHasSexImage:(NSArray *)sexImageNameArray {
//    self.publishButton.enabled = YES;
//    [SVProgressHUD dismiss];
//    NSMutableString *tips = [NSMutableString string];
//    [self.photoArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([sexImageNameArray containsObject:obj[@"name"]]) {
//            [tips appendString:[NSString stringWithFormat:@"%zd,",idx + 1]];
//        }
//    }];
//    if (tips.length) {
//        [tips deleteCharactersInRange:(NSRange){tips.length - 1, 1}];
//        [tips appendString:@"张图片违反了相关规定，无法发布"];
//        [tips insertString:@"您的第" atIndex:0];
//        [AlertViewTool showAlertViewWithTitle:@"提示" Message:tips buttonTitle:@"确定" sureBlock:^{
//            
//        }];
//    }
//}

- (void)pornImageWithUrls:(NSArray *)urlArray {
    NSMutableString *urlString = [NSMutableString string];
    for (NSString *url in urlArray) {
        [urlString appendString:url];
        [urlString appendString:@";"];
    }
    NSUInteger maxRange = NSMaxRange([urlString rangeOfComposedCharacterSequenceAtIndex:urlString.length - 2]);
    NSString *imageUrl = [urlString substringToIndex:maxRange];
    [self publishTrendsWithImageUrl:imageUrl];
}

- (void)publishTrendsWithImageUrl:(NSString *)imageUrl {
    [NetworkTool publishTrends:imageUrl
                         intro:self.trendsContent
                         video:nil cover:nil
                    trendsType:@"1"
                      duration:@""
                       success:^{
                           [self publishSuccess];
                       } failure:^{
                           [self publishFailure];
                       }];
}

- (void)publishSuccess {
    [SVProgressHUD dismiss];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_PublishSuccess object:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD showSuccessWithStatus:@"发布图文动态成功"];
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)publishFailure {
    self.publishButton.enabled = YES;
    [SVProgressHUD dismiss];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD showErrorWithStatus:@"发布图文动态失败"];
    });
}

#pragma mark -
#pragma mark - UICollectionView DataSource and Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductPhotoViewCell *cell_photo = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID_Photo forIndexPath:indexPath];
    cell_photo.photo = self.photoArray[indexPath.row][@"image"];
    cell_photo.index = indexPath.row;
    cell_photo.isShowDeleteButton = (indexPath.row == (self.photoArray.count - 1));
    
    __weak typeof(self) weakself = self;
    cell_photo.deletePhotoBlock = ^(NSUInteger index) {
        [weakself.photoArray removeObjectAtIndex:index];
        [weakself.collectionView reloadData];
    };
    
    return cell_photo;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        PublishProductFooterView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                  withReuseIdentifier:collectionViewCellID_Footer
                                                                                         forIndexPath:indexPath];
        footerview.photosSize = self.photosSize;
        __weak typeof(self) weakself = self;
        footerview.setUploadOrignalPhoto = ^(BOOL isUploadOrignalPhoto) {
            weakself.isUploadOrignalPhoto = isUploadOrignalPhoto;
        };
        reusableview = footerview;
    } else {
        PublishTrendsHeaderView *headerview = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                 withReuseIdentifier:collectionViewCellID_Header
                                                                                        forIndexPath:indexPath];
        __weak typeof(self) weakself = self;
        headerview.setContent = ^(NSString *content) {
            weakself.trendsContent = content;
            weakself.publishButton.enabled = content.length != 0;
        };
        reusableview = headerview;
    }
    
    return reusableview;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.photoArray.count - 1) {
        if (_photoArray.count > 9) {
            [SVProgressHUD showInfoWithStatus:@"照片数量已达上限"];
            return;
        }
        __weak typeof(self) weakself = self;
        [[TakePhotoHelp sharedInstance] showActionSheetWithTitle:@"配置动态图片" photosCount:_photoArray.count viewController:self returnBlock:^(BOOL isCover, NSArray<UIImage *> *photos) {
            if (!isCover) {
                NSMutableArray *dictArray = [NSMutableArray array];
                for (UIImage *image in photos) {
                    [dictArray addObject:@{@"image" : image, @"url" : @"", @"name" : [NSString randomString]}];
                }
                NSArray *oldArray = weakself.photoArray;
                NSMutableArray *muArray = [NSMutableArray array];
                [muArray addObjectsFromArray:dictArray];
                [muArray addObjectsFromArray:oldArray];
                weakself.photoArray = muArray;
                weakself.publishButton.enabled = weakself.trendsContent.length != 0;
            }
            [weakself.collectionView reloadData];
        }];
    }
}

@end
