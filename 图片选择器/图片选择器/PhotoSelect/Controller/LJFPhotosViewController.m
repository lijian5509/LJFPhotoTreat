//
//  LJFPhotosViewController.m
//  图片选择器
//
//  Created by Lone on 16/6/23.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "LJFPhotosViewController.h"
#import "LJFPhotoViewCell.h"

@interface LJFPhotosViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,
LJFPhotoViewCellDelegate,UIActionSheetDelegate>
{
    LJFPhotoViewCell *_previousSelectCell;          /**<标注之前选中的图片>*/
    NSInteger _currentSelectIndexOfCell;            /**<当前cell选中位置>*/
}
/**
 *  确认按钮
 */
@property (nonatomic, strong) UIButton *sureButton;

/**
 *  保存选中的图片
 */
@property (nonatomic, strong) NSMutableArray *selectPhotosArray;

/**
 *  获取导航栏对象
 */
@property (nonatomic, strong) LJFPhotoPickerController *pickerControl;

@end

@implementation LJFPhotosViewController

static NSString * const reuseIdentifier = @"Cell";

- (NSMutableArray *)selectPhotosArray
{
    if (!_selectPhotosArray) {
        _selectPhotosArray = [NSMutableArray new];
    }
    return _selectPhotosArray;
}

- (LJFPhotoPickerController *)pickerControl
{
    if (!_pickerControl) {
        _pickerControl = (LJFPhotoPickerController *)self.navigationController;
    }
    return _pickerControl;
}

- (instancetype)init
{
    if (self = [super initWithCollectionViewLayout:[LJFPhotosViewController initFlowLayout]]) {
        self.collectionView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[LJFPhotoViewCell class]
            forCellWithReuseIdentifier:reuseIdentifier];
    [self addNavigationItem];
}

#pragma mark - 添加导航栏按钮
- (void)addNavigationItem
{
    _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureButton.frame = CGRectMake(3, 0, 50, 44);
    [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
    _sureButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_sureButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    _sureButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _sureButton.enabled = NO;
    [_sureButton addTarget:self action:@selector(savePhoto:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_sureButton];
    
}

#pragma mark - 保存图片
- (void)savePhoto:(UIButton *)sender
{
    if (self.pickerControl.isSupportMultipleSelect) {//多选
        if (self.pickerControl.finishBlock) {
            self.pickerControl.finishBlock(self.selectPhotosArray);
            [self.pickerControl dismissViewControllerAnimated:YES completion:nil];
        }
    }else{
        if (self.pickerControl.singleFinishBlock) {
            LJFAssetModel *model = self.selectPhotosArray[0];
            UIImage *image = [UIImage imageWithCGImage:[model.representation fullScreenImage]];
            self.pickerControl.singleFinishBlock(image);
            [self.pickerControl dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LJFPhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.delegate          = self;
    LJFAssetModel *model   = self.dataArray[indexPath.row];
    cell.assetModel        = model;
    cell.iconBtn.selected  = [self.selectPhotosArray containsObject:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pickerControl.isSupportMultipleSelect) {
        LJFPhotoViewCell *cell = (LJFPhotoViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.iconBtn.selected = !cell.iconBtn.selected;
        [self LJFPhotoViewCell:cell PhotoSelectStateChanged:cell.iconBtn.selected];
        return;
    }
    _currentSelectIndexOfCell = indexPath.row;
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"浏览",@"编辑", nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    LJFAssetModel *model   = self.dataArray[_currentSelectIndexOfCell];
    UIImage *fullScreenImage = [UIImage imageWithCGImage:[model.representation fullScreenImage]];
    if (buttonIndex == 0) {//浏览
        LJFPhotoDetailController *VC = [LJFPhotoDetailController new];
        VC.originalImage = fullScreenImage;
        [self.navigationController pushViewController:VC animated:YES];
    }else if (buttonIndex == 1){//编辑
        LJFPhotoDrawController * VC = [[LJFPhotoDrawController alloc] init];
        VC.originalImage = fullScreenImage;
        [self.navigationController pushViewController:VC animated:YES];
    }
}

#pragma mark - 图片选中代理回调
- (void)LJFPhotoViewCell:(LJFPhotoViewCell *)photoCell PhotoSelectStateChanged:(BOOL)selected
{
   
    if (selected) {
        if (![self.selectPhotosArray containsObject:photoCell.assetModel]) {
            if (!self.pickerControl.isSupportMultipleSelect) {
                [self.selectPhotosArray removeAllObjects];
                if (_previousSelectCell) {
                    _previousSelectCell.iconBtn.selected = NO;
                }
            }
            [self.selectPhotosArray addObject:photoCell.assetModel];
        }
         _previousSelectCell = photoCell;
    }else{
        if ([self.selectPhotosArray containsObject:photoCell.assetModel]) {
            [self.selectPhotosArray removeObject:photoCell.assetModel];
        }
    }
    if (_selectPhotosArray.count > 0) {
        self.sureButton.enabled = YES;
    }else{
        self.sureButton.enabled = NO;
    }
}

#pragma mark - 创建布局
+ (UICollectionViewFlowLayout *)initFlowLayout
{
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    layOut.itemSize = CGSizeMake(90, 90);//item的大小
    // 设置每个cell上下左右相距
    layOut.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layOut.minimumInteritemSpacing = 10;
    layOut.minimumLineSpacing = 10;
    return layOut;
}

@end
