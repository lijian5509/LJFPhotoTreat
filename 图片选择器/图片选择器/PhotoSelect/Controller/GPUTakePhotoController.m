//
//  GPUTakePhotoController.m
//  图片选择器
//
//  Created by Lone on 16/7/20.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "GPUTakePhotoController.h"
#import "GPUImage.h"

typedef void(^FinishBlock)(UIImage *image);
typedef void(^CancelBlock)(void);

@interface GPUTakePhotoController ()

@property (nonatomic, strong) GPUImageStillCamera *photoCamera;     /**<相机>*/
@property (nonatomic, strong) GPUImageView *filterView;             /**<画面>*/
@property (nonatomic, strong) GPUImageSaturationFilter *saturationFilter;     /**<图像饱和度>*/
@property (nonatomic, copy)   FinishBlock   finishBlcok;
@property (nonatomic, copy)   CancelBlock   cancelBlcok;

@end

@implementation GPUTakePhotoController

#pragma mark - 设置屏幕方向
- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    
    return UIInterfaceOrientationLandscapeRight;
}

- (instancetype)initWithBlcokFinish:(void (^)(UIImage *))finish
                             cancel:(void (^)())cancel
{
    self = [super init];
    if (self) {
        self.finishBlcok = finish;
        self.cancelBlcok = cancel;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //聚焦
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    
    if([_photoCamera.inputCamera isFocusPointOfInterestSupported]
       &&[_photoCamera.inputCamera isFocusModeSupported:AVCaptureFocusModeAutoFocus])
    {
        if([_photoCamera.inputCamera lockForConfiguration :nil])
        {
            [_photoCamera.inputCamera setFocusPointOfInterest :touchPoint];
            [_photoCamera.inputCamera setFocusMode :AVCaptureFocusModeLocked];
            if([_photoCamera.inputCamera isExposurePointOfInterestSupported])
            {
                [_photoCamera.inputCamera setExposurePointOfInterest:touchPoint];
                [_photoCamera.inputCamera setExposureMode:AVCaptureExposureModeLocked];
            }
            [_photoCamera.inputCamera unlockForConfiguration];
        }
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configCamera];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - 配置相机
- (void)configCamera
{
    _photoCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480
                                                       cameraPosition:AVCaptureDevicePositionBack];
    _photoCamera.outputImageOrientation = UIInterfaceOrientationLandscapeRight;
    _photoCamera.horizontallyMirrorFrontFacingCamera = YES;
    _saturationFilter = [[GPUImageSaturationFilter alloc] init];
    [_photoCamera addTarget:_saturationFilter];
    
    _filterView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width)];
    [_saturationFilter addTarget:_filterView];
    [self.view insertSubview:_filterView atIndex:0];
    
    [_photoCamera startCameraCapture];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)itemSelected:(UIBarButtonItem *)sender {
    
    switch (sender.tag) {
        case 0:
        {
            [_photoCamera capturePhotoAsJPEGProcessedUpToFilter:_saturationFilter
                                                withOrientation:UIImageOrientationUp
                                          withCompletionHandler:^(NSData *processedJPEG, NSError *error) {
                                              UIImage *image = [UIImage imageWithData:processedJPEG];
                                              self.finishBlcok(image);
                                              [self dismissViewControllerAnimated:YES
                                                                       completion:nil];
                                          }];
        }
            break;
        case 1:
        {
            self.cancelBlcok();
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
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
