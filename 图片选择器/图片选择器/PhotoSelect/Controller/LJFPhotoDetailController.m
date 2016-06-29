//
//  LJFPhotoDetailController.m
//  图片选择器
//
//  Created by Lone on 16/6/24.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "LJFPhotoDetailController.h"

@interface LJFPhotoDetailController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;

//@property (nonatomic, strong) UIImage *fixedImage;

/**
 *  裁剪区域
 */
@property (nonatomic) CGRect cropRect;
/**
 *  工具栏显示状态
 */
@property (nonatomic) BOOL hidden;
/**
 *  scroview
 */
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
/**
 *  底部工具框
 */
@property (weak, nonatomic) IBOutlet UIToolbar *bottomBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomBar_bottom_constraint;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightItem;

@end

@implementation LJFPhotoDetailController

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView                        = [[UIImageView alloc] initWithImage:self.originalImage];
        _imageView.userInteractionEnabled = YES;
        CGSize size                       = [self calculateViewFitSizeWithImage:self.originalImage
                                                                      planWidth:ScreenWidth
                                                                     planHeight:ScreenHeight];
        _imageView.frame                  = CGRectMake(0, 0, size.width, size.height);
    }
    return _imageView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self viewForZoomingInScrollView:self.scrollView];
    [self scrollViewDidZoom:self.scrollView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTapGesture];
    [self configUI];
    self.title = @"图片浏览";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.rightItem setTitle:[NSString stringWithFormat:@"%.1f(M)",
                              UIImagePNGRepresentation(self.originalImage).length/ (1024.0 * 1024.0)]];
    if (self.isJustLook) {
        self.bottomBar.hidden = YES;
    }
//    [self addNaviGationBarItem];
    //    [self drawCropBoard];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - 添加手势
- (void)addTapGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark - 初始化UI
- (void)configUI
{
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight);
    [self.scrollView addSubview:self.imageView];
}

#pragma mark - 创建细线
- (UILabel *)creatLineWith:(CGRect)frame
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor redColor];
    return label;
}

#pragma makr - 单点手势
- (void)tap:(UITapGestureRecognizer *)tap
{
    self.hidden = !self.hidden;
    if (self.hidden) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomBar_bottom_constraint.constant += 44;
        }];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomBar_bottom_constraint.constant += -44;
        }];
    }
}

#pragma mark - scrollView delegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}


#pragma mark - 跳转到绘制页面
- (IBAction)brushImage:(id)sender {
    LJFPhotoDrawController * VC = [[LJFPhotoDrawController alloc] init];
    VC.originalImage = self.originalImage;
    [self.navigationController pushViewController:VC animated:YES];
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

/**
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
    //    self.originalImage = [self getImageFromImageView:self.imageView
    //                                              withRect:self.cropRect];
    //    [self.imageView removeFromSuperview];
    //    self.imageView = nil;
    //    [self configUI];
    //    [self.scrollView setZoomScale:1 animated:YES];
}

/**
 *  图片不放大的状况
 *
 *  @return return value description
 */

/**
-(UIImage*) cropImage{
    CGRect rect = self.cropRect;
    CGFloat koef = self.imageView.image.size.width / self.scrollView.frame.size.width;
    CGRect finalImageRect = CGRectMake(rect.origin.x*koef, rect.origin.y*koef, rect.size.width*koef, rect.size.height*koef);
    UIImage *croppedImage = [self.imageView.image imageAtRect:finalImageRect];
    return croppedImage;
}
#pragma mark - 图片裁剪
//裁剪修改后的图片
-(UIImage *)getImageFromImageView:(UIImageView *)imageView withRect:(CGRect)rect{
    
    CGRect subRect = [self.view convertRect:rect toView:imageView];
    UIImage *changedImage = [self createChangedImageWithImageView:imageView];
    UIGraphicsBeginImageContext(subRect.size);
    [changedImage drawInRect:CGRectMake(-subRect.origin.x,-subRect.origin.y,changedImage.size.width,changedImage.size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
//创建修改后的图片
-(UIImage *)createChangedImageWithImageView:(UIImageView *)imageView{
    UIGraphicsBeginImageContext(imageView.image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [imageView.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 画裁剪框
- (void)drawCropBoard
{
    CGFloat cropWidth = ScreenWidth - 10;
    CGFloat cropHeght = ((ScreenWidth - 10)/4*3);
    CGPoint center = self.view.center;
    CGPoint point1 = CGPointMake(center.x - cropWidth/2, center.y - cropHeght/2);
    UILabel *line1 = [self creatLineWith:CGRectMake(point1.x, point1.y, 1, cropHeght)];
    UILabel *line2 = [self creatLineWith:CGRectMake(point1.x, point1.y, cropWidth, 1)];
    UILabel *line3 = [self creatLineWith:CGRectMake(point1.x + cropWidth, point1.y, 1, cropHeght)];
    UILabel *line4 = [self creatLineWith:CGRectMake(point1.x, point1.y + cropHeght, cropWidth, 1)];
    [self.view addSubview:line1];
    [self.view addSubview:line2];
    [self.view addSubview:line3];
    [self.view addSubview:line4];
    self.cropRect = CGRectMake(point1.x, point1.y, cropWidth, cropHeght);
}

**/

@end
