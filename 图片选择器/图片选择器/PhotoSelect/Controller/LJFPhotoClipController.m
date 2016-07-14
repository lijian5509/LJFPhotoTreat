//
//  CircularClipView.m
//  MasonryDemo
//
//  Created by Lone on 16/6/30.
//  Copyright © 2016年 Lone. All rights reserved.
//

#import "LJFPhotoClipController.h"
@interface LJFPhotoClipController ()

@end

@implementation LJFPhotoClipController

-(instancetype)initWithImage:(UIImage *)image
{
    if(self = [super init])
    {
        _image = [self fixOrientation:image];
        self.clipType = CIRCULARCLIP;
        self.radius = 120;
        self.scaleRation = 3;
        _lastScale = 1.0;
    }
    return  self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self configUI];
    [self addAllGesture];
    [self addNaviGationBarItem];
    self.title = @"照片裁剪";
}
#pragma mark - 添加导航栏右按钮
- (void)addNaviGationBarItem
{
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(3, 0, 50, 44);
    [sureBtn setTitle:@"下一步" forState:UIControlStateNormal];
    sureBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    sureBtn.enabled = NO;
    [sureBtn addTarget:self action:@selector(sureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sureBtn];
}

#pragma mark - 确认
- (void)sureBtnClicked:(UIButton *)sender
{
    LJFPhotoDrawController * VC = [[LJFPhotoDrawController alloc] init];
    VC.originalImage = _image;
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)configUI
{
    //验证 裁剪半径是否有效
    self.radius= self.radius > self.view.frame.size.width/2?self.view.frame.size.width/2:self.radius;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _imageView = [[UIImageView alloc]init];
    [_imageView setImage:_image];
    CGSize size = [self calculateViewFitSizeWithImage:_image planWidth:self.view.frame.size.width planHeight:self.view.frame.size.height];
    [_imageView setFrame:CGRectMake(0, 0, size.width, size.height)];
    [_imageView setCenter:self.view.center];
    self.originalFrame = _imageView.frame;
    [self.view addSubview:_imageView];
    
    //覆盖层
    _overView = [[UIView alloc]init];
    [_overView setBackgroundColor:[UIColor clearColor]];
    _overView.opaque = NO;
    [_overView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height )];
    [self.view addSubview:_overView];
    
    UIButton * clipBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [clipBtn setTitle:@"裁剪" forState:UIControlStateNormal];
    [clipBtn addTarget:self action:@selector(clipBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    [clipBtn setBackgroundColor:[UIColor whiteColor]];
    [clipBtn setFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    [self.view addSubview:clipBtn];
    
    [self drawClipPath:self.clipType];
}

- (void)setClipSize:(CGSize)clipSize
{
    _clipSize = clipSize;
}

#pragma mark - 绘制裁剪边框
-(void)drawClipPath:(ClipType )clipType
{
    CGPoint center = self.view.center;
    if (self.clipSize.width <= 0) {
        self.circularFrame = CGRectMake(center.x - self.radius, center.y - self.radius, self.radius * 2, self.radius * 2);
    }else{
        self.circularFrame = CGRectMake(center.x - self.clipSize.width/2, center.y - self.clipSize.height/2, self.clipSize.width, self.clipSize.height);
    }
    UIBezierPath * path= [UIBezierPath bezierPathWithRect:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    //绘制圆形裁剪区域
    if(clipType == CIRCULARCLIP)
    {
        [path  appendPath:[UIBezierPath bezierPathWithArcCenter:self.view.center radius:self.radius startAngle:0 endAngle:2*M_PI clockwise:NO]];
    }
    else
    {
        [path appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(self.circularFrame.origin.x, self.circularFrame.origin.y, self.circularFrame.size.width, self.circularFrame.size.height)]];
    }
    [path setUsesEvenOddFillRule:YES];
    layer.path = path.CGPath;
    layer.fillRule = kCAFillRuleEvenOdd;
    layer.fillColor = [[UIColor blackColor] CGColor];
    layer.opacity = 0.5;
    [_overView.layer addSublayer:layer];
}

#pragma mark - 添加手势
-(void)addAllGesture
{
    //捏合手势
    UIPinchGestureRecognizer * pinGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinGesture:)];
    [self.view addGestureRecognizer:pinGesture];
    //拖动手势
    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:panGesture];
}

#pragma mark - 捏合手势
-(void)handlePinGesture:(UIPinchGestureRecognizer *)pinGesture
{
    UIView * view = _imageView;
    if(pinGesture.state == UIGestureRecognizerStateBegan || pinGesture.state == UIGestureRecognizerStateChanged)
    {
        pinGesture.scale = pinGesture.scale - _lastScale + 1;
        view.transform = CGAffineTransformScale(view.transform, pinGesture.scale, pinGesture.scale);
        _lastScale = pinGesture.scale;
    }
    else if(pinGesture.state == UIGestureRecognizerStateEnded)
    {
        CGFloat ration =  view.frame.size.width /self.originalFrame.size.width;
        /**
         *  当放大倍数大于设定的放大倍数的时候 图片的size 设置成原始size * 放大倍数
         */
        if(ration>_scaleRation)
        {
            CGRect newFrame =CGRectMake(0, 0, self.originalFrame.size.width * _scaleRation, self.originalFrame.size.height * _scaleRation);
            view.frame = newFrame;
            /**
             *  当缩小的比例的长宽都小玉裁剪框时，以最接近裁剪框的宽度或者长度为基准，等比例放大直至已属性长度和裁剪框长度相等
             */
        }else if (view.frame.size.width < self.circularFrame.size.width && view.frame.size.height< self.circularFrame.size.height)
        {
            CGFloat rat = self.originalFrame.size.height / self.originalFrame.size.width;
            CGFloat newHeight;
            CGFloat newWidth;
            if (rat > 1) {//若高度大与宽度 已高为准
                newHeight = self.circularFrame.size.height;
                newWidth  = self.circularFrame.size.height/rat;
            }else{
                newWidth = self.circularFrame.size.width;
                newHeight  = self.circularFrame.size.width * rat;
            }
            
            CGRect newFrame =CGRectMake(0, 0, newWidth,newHeight);
            view.frame = newFrame;
        }
        [view setCenter:self.view.center];
        self.currentFrame = view.frame;
    }
}

#pragma mark - 拖拽手势
-(void)handlePanGesture:(UIPanGestureRecognizer *)panGesture
{
    UIView * view = _imageView;
    if(panGesture.state == UIGestureRecognizerStateBegan || panGesture.state == UIGestureRecognizerStateChanged)
    {
        /**
         *  坐标点转换
         */
        CGPoint translation = [panGesture translationInView:view.superview];
        [view setCenter:CGPointMake(view.center.x + translation.x, view.center.y + translation.y)];
        [panGesture setTranslation:CGPointZero inView:view.superview];
    }
    else if ( panGesture.state == UIGestureRecognizerStateEnded)
    {
        //坐标转换 相对于当前视图 这样比较精准
        CGRect currentFrame = [self.view convertRect:_imageView.frame toView:self.view];
        //超出四个角居中 以四个角为界限，只要超出一角就要默认居中
        if((currentFrame.origin.x >= self.circularFrame.origin.x && currentFrame.origin.y >= self.circularFrame.origin.y)
           || (currentFrame.size.width + currentFrame.origin.x < self.circularFrame.origin.x + self.circularFrame.size.width && currentFrame.origin.y >= self.circularFrame.origin.y)
           || (currentFrame.size.height+currentFrame.origin.y < self.circularFrame.origin.y + self.circularFrame.size.height && currentFrame.origin.x >= self.circularFrame.origin.x)
           || (currentFrame.size.height+currentFrame.origin.y < self.circularFrame.origin.y + self.circularFrame.size.height && currentFrame.size.width + currentFrame.origin.x < self.circularFrame.origin.x + self.circularFrame.size.width))
        {
            [UIView animateWithDuration:0.05 animations:^{
                view.center = self.view.center;
            }];
        }
    }
}

#pragma mark - 裁剪
-(void)clipBtnSelected:(UIButton *)btn
{
    LJFPhotoDrawController * VC = [[LJFPhotoDrawController alloc] init];
    VC.originalImage = [self getSmallImage];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - 调整Image 的方形
-(UIImage *)fixOrientation:(UIImage *)image
{
    if (image.imageOrientation == UIImageOrientationUp)
        return image;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

#pragma mark - 方形裁剪
-(UIImage *)getSmallImage
{
    CGFloat rationScale = (_imageView.frame.size.width /_image.size.width);
    CGRect rect1 = [self.view convertRect:self.circularFrame toView:self.view];
    CGRect rect2 = [self.view convertRect:_imageView.frame toView:self.view];
    
#pragma mark - 根据imageView 的frame 等比例映射到image
    CGFloat origX = (rect1.origin.x - rect2.origin.x) / rationScale;
    CGFloat origY = (rect1.origin.y - rect2.origin.y) / rationScale;
    CGFloat oriWidth = rect1.size.width / rationScale;
    CGFloat oriHeight = rect1.size.height / rationScale;
    //    CGFloat origX = (self.circularFrame.origin.x - _imageView.frame.origin.x) / rationScale;
    //    CGFloat origY = (self.circularFrame.origin.y - _imageView.frame.origin.y) / rationScale;
    //    CGFloat oriWidth = self.circularFrame.size.width / rationScale;
    //    CGFloat oriHeight = self.circularFrame.size.height / rationScale;
    
    CGRect myRect = CGRectMake(origX, origY, oriWidth, oriHeight);
    CGImageRef  imageRef = CGImageCreateWithImageInRect(_image.CGImage, myRect);
    UIGraphicsBeginImageContext(myRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myRect, imageRef);
    UIImage * clipImage = [UIImage imageWithCGImage:imageRef];
    UIGraphicsEndImageContext();
    
    if(self.clipType == CIRCULARCLIP)
        return  [self circularClipImage:clipImage];
    
    return clipImage;
}

#pragma mark - 圆形裁剪
-(UIImage *)circularClipImage:(UIImage *)image
{
    CGFloat arcCenterX = image.size.width/ 2;
    CGFloat arcCenterY = image.size.height / 2;
    
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextAddArc(context, arcCenterX , arcCenterY, image.size.width/ 2 , 0.0, 2*M_PI, NO);
    CGContextClip(context);
    CGRect myRect = CGRectMake(0 , 0, image.size.width ,  image.size.height);
    [image drawInRect:myRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
}

@end
