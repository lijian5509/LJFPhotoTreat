//
//  LJFPhotoDetailController.h
//  图片选择器
//
//  Created by Lone on 16/6/24.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJFPhotoDetailController : UIViewController

/**
 *  原图
 */
@property (nonatomic, strong) UIImage * originalImage;

/**
 *  是否只是查看 是：隐藏底部操作栏
 */
@property (nonatomic) BOOL isJustLook;

@end
