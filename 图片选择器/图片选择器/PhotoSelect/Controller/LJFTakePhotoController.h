//
//  LJFTakePhotoController.h
//  图片选择器
//
//  Created by Lone on 16/7/6.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 拍照方向
 */
typedef enum {
    TakePhotoOrientationProtrait = 0,
    TakePhotoOrientationRight,
    //一下两种暂时禁用
    TakePhotoOrientationUpsideDown,
    TakePhotoOrientationLeft,
}TakePhotoOrientation;

@class LJFTakePhotoController;
@protocol LJFTakePhotoControllerDelegate <NSObject>

@optional
- (void)LJFTakePhotoController:(LJFTakePhotoController *)photoControl
               didFinishWithImage:(UIImage *)image;
- (void)LJFTakePhotoControllerDidCancel;

@end

@interface LJFTakePhotoController : UIViewController

- (instancetype)initWithDelegate:(id<LJFTakePhotoControllerDelegate>)delegate
            takePhotoOrientation:(TakePhotoOrientation)orientation;

/**
 *  背景遮罩图
 */
@property (nonatomic, strong) UIImage *backImage;

@end
