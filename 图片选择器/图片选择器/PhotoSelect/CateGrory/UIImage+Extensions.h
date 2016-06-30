//
//  UIImage+Extensions.h
//  OCR
//
//  Created by ren6 on 2/14/13.
//  Copyright (c) 2013 ren6. All rights reserved.
//

//
//  UIImage-Extensions.h
//
//  Created by Hardy Macia on 7/1/09.
//  Copyright 2009 Catamount Software. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface UIImage (Extensions)
/**
 *  裁剪
 *
 *  @param rect 裁剪区域
 *
 *  @return return value description
 */
- (UIImage *)imageAtRect:(CGRect)rect;

- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;

/**
 *  image旋转
 *
 *  @param degrees degrees description
 *
 *  @return return value description
 */
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

/**
 *  等比例缩放到指定大小
 *
 *  @param size size description
 *
 *  @return return value description
 */
- (UIImage *)scaleToSize:(CGSize)size;
/**
 *  设置画布底色并在指定区域内等比例绘制图片
 *
 *  @param color color description
 *  @param size  size description
 *
 *  @return return value description
 */
- (UIImage *)drawImageWithBackColor:(UIColor *)color targetSize:(CGSize)size;

@end;