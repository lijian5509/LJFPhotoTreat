//
//  LJFPhotoDrawController.m
//  图片选择器
//
//  Created by Lone on 16/6/25.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "LJFPhotoDrawController.h"
#import "LJFPhotoTweaksController.h"

@interface LJFPhotoDrawController ()

@property (nonatomic, strong) UIImage *fixedImage;          /**<编辑的图片>*/

@property (weak, nonatomic) IBOutlet LJFScrawView *imageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBar_bottom_constraint;

@property (nonatomic, strong) UIImageView *backImageView;
/**
 *  工具栏显示状态
 */
@property (nonatomic) BOOL hidden;


@end

@implementation LJFPhotoDrawController

- (UIImageView *)backImageView
{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    }
    return _backImageView;
}

- (void)setOriginalImage:(UIImage *)originalImage
{
    _originalImage = originalImage;
    self.fixedImage = originalImage;
}

- (void)setFixedImage:(UIImage *)fixedImage
{
    _fixedImage = fixedImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"照片涂抹";
    [self addTapGesture];
    [self addNaviGationBarItem];
    [self configData];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - 初始化数据
- (void)configData
{
    self.imageView.brush = [[LJFPencilBrush alloc] init];
    self.imageView.strokeWidth = 5.0;
    self.imageView.strokeColor = [UIColor whiteColor];
    self.imageView.image = self.fixedImage;
    self.imageView.realImage = nil;
}

#pragma mark - 添加导航栏右按钮
- (void)addNaviGationBarItem
{
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(3, 0, 50, 44);
    [sureBtn setTitle:@"保存" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    sureBtn.enabled = NO;
    [sureBtn addTarget:self action:@selector(sureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sureBtn];
}

#pragma mark - 确认
- (void)sureBtnClicked:(UIButton *)sender
{
    LJFPhotoPickerController  *picker = (LJFPhotoPickerController *)self.navigationController;
    if (picker.singleFinishBlock) {
        picker.singleFinishBlock(self.imageView.image);
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 添加手势
- (void)addTapGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
}

#pragma makr - 单点手势
- (void)tap:(UITapGestureRecognizer *)tap
{
    self.hidden = !self.hidden;
    if (self.hidden) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [UIView animateWithDuration:0.25 animations:^{
            self.toolBar_bottom_constraint.constant += -44;
        }];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [UIView animateWithDuration:0.25 animations:^{
            self.toolBar_bottom_constraint.constant += 44;
        }];
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

- (IBAction)resetImageView:(id)sender {
    self.fixedImage = self.originalImage;
    self.imageView.image = self.fixedImage;
    self.imageView.realImage = nil;
}

- (IBAction)cropImageView:(id)sender {
    LJFPhotoTweaksController *photoTweaksViewController = [[LJFPhotoTweaksController alloc] initWithImage:self.imageView.image];
    photoTweaksViewController.autoSaveToLibray = YES;
    photoTweaksViewController.maxRotationAngle = M_PI_4;
    [self.navigationController pushViewController:photoTweaksViewController animated:YES];
}
@end
