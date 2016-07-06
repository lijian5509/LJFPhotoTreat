//
//  LJFAlbumsListController.m
//  图片选择器
//
//  Created by Lone on 16/6/21.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "LJFAlbumsListController.h"
#import "LJFPhotosViewController.h"
#import "LJFPhotoOverView.h"
#import "LJFAlbumTableViewCell.h"

@interface LJFAlbumsListController ()<UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate,
UINavigationControllerDelegate,LJFTakePhotoControllerDelegate>

@end

@implementation LJFAlbumsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"相册列表";
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame
                                                  style:UITableViewStyleGrouped];
    [self addNaviGationBarItem];
    [self loadData];
}

- (void)loadData
{
    [[LJFPhotoHandle shareInstance] ljf_getAlbumsWithAlbumType:LJFGetAllAlbums
                                                       success:^(NSArray<LJFAssetsGroupModel *> *alblums) {
                                                           self.dataArray = alblums;
                                                           [self.tableView reloadData];
                                                       }
                                                          fail:^(NSError *error) {
                                                              NSLog(@"获取照片资源失败");
                                                          }];
}

#pragma mark - 添加导航栏右按钮
- (void)addNaviGationBarItem
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePhoto)];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(3, 0, 50, 44);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    cancelBtn.enabled = NO;
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
}

#pragma mark - 添加导航栏按钮
- (void)cancel
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 拍照
- (void)takePhoto
{
    LJFTakePhotoController *VC = [[LJFTakePhotoController alloc] initWithDelegate:self
                                                             takePhotoOrientation:TakePhotoOrientationRight];
    VC.backImage = [UIImage imageNamed:@"for0"];
    [self presentViewController:VC animated:YES completion:nil];
//    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
//    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    imagePicker.showsCameraControls = NO;
//    imagePicker.allowsEditing = YES;
//    imagePicker.delegate = self;
//    LJFPhotoOverView *overView = [[[NSBundle mainBundle] loadNibNamed:@"LJFPhotoOverView"
//                                                                owner:self
//                                                              options:nil]lastObject];
//    overView.backImageView.image = [UIImage imageNamed:@"for0"];
//    overView.frame = imagePicker.cameraOverlayView.frame;
//    imagePicker.cameraOverlayView = overView;
//    overView.pickerControl = imagePicker;
//    imagePicker.navigationBarHidden = YES;
//    CGAffineTransform cameraTransform = CGAffineTransformScale(imagePicker.cameraViewTransform,1.5,1.5);
//    imagePicker.cameraViewTransform = cameraTransform;
//    [self presentViewController:imagePicker
//                       animated:YES
//                     completion:nil];
}

#pragma mark - 拍照回调
-(void)LJFTakePhotoController:(LJFTakePhotoController *)photoControl didFinishWithImage:(UIImage *)image
{
    [photoControl dismissViewControllerAnimated:YES completion:nil];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    LJFPhotoDetailController *VC = [LJFPhotoDetailController new];
    VC.originalImage = image;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - 图片选择完毕（单选)
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
    if (image == nil) {
        image = info[@"UIImagePickerControllerOriginalImage"];
    }
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    [picker dismissViewControllerAnimated:YES completion:nil];

    LJFPhotoDetailController *VC = [LJFPhotoDetailController new];
    VC.originalImage = image;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"
//                                                    message:msg
//                                                   delegate:self
//                                          cancelButtonTitle:@"确定"
//                                          otherButtonTitles:nil];
//    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"album";
    LJFAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LJFAlbumTableViewCell"
                                              owner:self
                                            options:nil]
                lastObject];
    }
    LJFAssetsGroupModel *group = self.dataArray[indexPath.row];
    cell.nameLabel.text = group.assetsName;
    cell.describeLabel.text = [NSString stringWithFormat:@"%ld张",group.assetsNumbers];
    cell.backImageView.image = group.posterImage;
    
    return cell;
}

#pragma mark 0 相册选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LJFAssetsGroupModel *group = self.dataArray[indexPath.row];
    [[LJFPhotoHandle shareInstance] ljf_getAllPhotosWithAssetesGroup:group.assetsGroup
                                                           assetType:LJFPhotoTypeAll
                                                             success:^(NSArray<LJFAssetModel *> *alblums) {
                                                                 
                                                                 LJFPhotosViewController *VC = [LJFPhotosViewController new];
                                                                 VC.dataArray = alblums;
                                                                 VC.title = group.assetsName;
                                                                 [self.navigationController pushViewController:VC animated:YES];
                                                             }
                                                                fail:^(NSError *error) {
                                                                    NSLog(@"获取出错");
                                                                }];
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
