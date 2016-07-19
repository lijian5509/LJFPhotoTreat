//
//  LJFTakePhotoController.m
//  图片选择器
//
//  Created by Lone on 16/7/6.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "LJFTakePhotoController.h"
#import <AVFoundation/AVFoundation.h>

@interface LJFTakePhotoController ()
{
    UIImageOrientation imageOrientation;
    float view_height;  //当前control 的高度
    float view_width;   //当前control 的宽度
}
@property (nonatomic, strong)       AVCaptureSession            * session;          /**<AVCaptureSession对象来执行输入设备和输出设备之间的数据传递>*/
@property (nonatomic, strong)       AVCaptureDeviceInput        * videoInput;       /**<AVCaptureDeviceInput对象是输入流>*/
@property (nonatomic, strong)       AVCaptureStillImageOutput   * stillImageOutput; /**<照片输出流对象，当然我的照相机只有拍照功能，所以只需要这个对象就够了>*/
@property (nonatomic, strong)       AVCaptureVideoPreviewLayer  * previewLayer;     /**</预览图层，来显示照相机拍摄到的画面>*/
@property (nonatomic, strong)       UIBarButtonItem             * toggleButton;     /**<切换前后镜头的按钮>*/
@property (nonatomic, strong)       UIButton                    * shutterButton;    /**<拍照按钮>*/
@property (nonatomic, strong)       UIImageView                 * cameraShowView;   /**<放置预览图层的View>*/
@property (nonatomic, weak)    id<LJFTakePhotoControllerDelegate> delegate;         /**<代理>*/
@property (nonatomic)               TakePhotoOrientation          orientation;      /**<拍摄方向>*/
@property (nonatomic, )             UIToolbar                   * bottomToolBar;    /**<底部工具栏>*/

@end

@implementation LJFTakePhotoController


- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if (self.orientation == TakePhotoOrientationRight) {
        return UIInterfaceOrientationMaskLandscapeRight;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    if (self.orientation == TakePhotoOrientationRight) {
        return UIInterfaceOrientationLandscapeRight;
    }
    return UIInterfaceOrientationPortrait;
}

- (instancetype)initWithDelegate:(id<LJFTakePhotoControllerDelegate>)delegate takePhotoOrientation:(TakePhotoOrientation)orientation
{
    if (self = [super init]) {
        self.delegate = delegate;
        self.orientation = orientation;
        [self initialSession];
    }
    return self;
}

#pragma mark 预览图
- (UIImageView *)cameraShowView
{
    if (!_cameraShowView) {
        _cameraShowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view_width, view_height - 44)];
        _cameraShowView.image = self.backImage;
    }
    return _cameraShowView;
}

- (UIToolbar *)bottomToolBar
{
    if (!_bottomToolBar) {
        _bottomToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, view_height - 44, view_width, 44)];
        UIBarButtonItem *item_cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                     target:self
                                                                                     action:@selector(takePhotoCancel)];
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:self
                                                                                  action:nil];
        
        UIBarButtonItem *sure_item = [[UIBarButtonItem alloc] initWithTitle:@"拍照"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(shutterCamera)];
        _bottomToolBar.items = @[item_cancel,flexible,sure_item];;
        
    }
    return _bottomToolBar;
}



#pragma mark - 初始化摄像头
- (void)initialSession
{
    //这个方法的执行我放在init方法里了
    self.session = [[AVCaptureSession alloc] init];
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:nil];
    //[self fronCamera]方法会返回一个AVCaptureDevice对象，因为我初始化时是采用前摄像头，所以这么写，具体的实现方法后面会介绍
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    //这是输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
    [self.stillImageOutput setOutputSettings:outputSettings];
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
}

#pragma mark - 获取前后摄像头
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

- (AVCaptureDevice *)frontCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

- (AVCaptureDevice *)backCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

#pragma mark - 设置预览图层
- (void)setUpCameraLayer
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) return;
    if (_previewLayer == nil) {
        _previewLayer =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        _previewLayer.frame =CGRectMake(0,0,view_width,view_height - 44);
        [self.view.layer insertSublayer:_previewLayer atIndex:0];
    }
    [self changePreviewOrientation:self.orientation];
}

#pragma mark - 调整摄入屏幕方向
- (void)changePreviewOrientation:(TakePhotoOrientation)interfaceOrientation
{
    if (!_previewLayer) {
        return;
    }
    [CATransaction begin];
    if (self.orientation == TakePhotoOrientationRight) {
        imageOrientation = UIImageOrientationUp;
        _previewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
        
    }else if (self.orientation == TakePhotoOrientationLeft){
        imageOrientation = UIImageOrientationUp;
        _previewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
        
    }else if (self.orientation == TakePhotoOrientationProtrait){
        imageOrientation = UIImageOrientationRight;
        _previewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
        
    }else if (self.orientation == TakePhotoOrientationUpsideDown){
        imageOrientation = UIImageOrientationLeft;
        _previewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
    }
    [CATransaction commit];
}

#pragma mark - 切换前后摄像头
- (void)exchangeCamera{
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount > 1) {
        NSError *error;
        AVCaptureDeviceInput *newVideoInput;
        AVCaptureDevicePosition position = [[_videoInput device] position];
        
        if (position == AVCaptureDevicePositionBack)
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:&error];
        else if (position == AVCaptureDevicePositionFront)
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:&error];
        else
            return;
        if (newVideoInput != nil) {
            [self.session beginConfiguration];
            [self.session removeInput:self.videoInput];
            if ([self.session canAddInput:newVideoInput]) {
                [self.session addInput:newVideoInput];
                [self setVideoInput:newVideoInput];
            } else {
                [self.session addInput:self.videoInput];
            }
            [self.session commitConfiguration];
        } else if (error) {
            NSLog(@"toggle carema failed, error = %@", error);
        }
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.session) {
        [self.session startRunning];
    }
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear: animated];
    if (self.session) {
        [self.session stopRunning];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    [self setUpCameraLayer];
    // Do any additional setup after loading the view.
}

#pragma mark - 添加子视图
- (void)initSubViews
{
    if (self.orientation == TakePhotoOrientationRight) {
        view_width  = self.view.frame.size.height;
        view_height = self.view.frame.size.width;
    }else{
        view_width  = self.view.frame.size.width;
        view_height = self.view.frame.size.height;
    }
    [self.view addSubview:self.cameraShowView];
    [self.view addSubview:self.bottomToolBar];
}

#pragma mark - 取消拍摄
- (void)takePhotoCancel
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(LJFTakePhotoControllerDidCancel)]) {
        [self.delegate LJFTakePhotoControllerDidCancel];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 拍照
- (void)shutterCamera
{
    AVCaptureConnection * videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        return;
    }
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage * image = [UIImage imageWithData:imageData];
        UIImage *realImage = [UIImage imageWithCGImage:image.CGImage scale:1 orientation:UIImageOrientationUp];
        NSLog(@"image size = %@",NSStringFromCGSize(image.size));
        if (self.delegate && [self.delegate respondsToSelector:@selector(LJFTakePhotoController:didFinishWithImage:)]) {
            [self.delegate LJFTakePhotoController:self didFinishWithImage:realImage];
        }
    }];
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

@end
