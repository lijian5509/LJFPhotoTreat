//
//  GPUTakePhotoController.h
//  图片选择器
//
//  Created by Lone on 16/7/20.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPUTakePhotoController : UIViewController

/**
 *  初始化方法
 *
 *  @param finish 拍照回调
 *  @param cancel 取消回调
 *
 *  @return return value description
 */
- (instancetype)initWithBlcokFinish:(void(^)(UIImage *image))finish
                             cancel:(void(^)())cancel;

@end
