//
//  NSObject+ImageRect.h
//  照片涂鸦
//
//  Created by Lone on 16/5/23.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject(ImageRect)

/**
 *  获取image 在imageView的frame
 *
 *  @param image     image
 *  @param imageView imageView
 *
 *  @return return value description
 */
- (CGRect)getFrameSizeForImage:(UIImage *)image
                   inImageView:(UIImageView *)imageView;


/**
 *  根据image 计算等比例size
 *
 *  @param image      image
 *  @param planWidth  计划宽度
 *  @param planHeight 计划高度
 *
 *  @return return value description
 */
- (CGSize)calculateViewFitSizeWithImage:(UIImage *)image
                              planWidth:(CGFloat)planWidth
                             planHeight:(CGFloat)planHeight;

/**
 *  图片绘制指定大小
 *
 *  @param image image description
 *  @param size  size description
 *
 *  @return return value description
 */
- (UIImage *)scaleToSize:(UIImage *)image size:(CGSize)size;

/**
 *  图片截取
 *
 *  @param image image description
 *  @param rect  rect description
 *
 *  @return return value description
 */
- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect;

/**
 *  图片压缩到指定大小
 *
 *  @param originalImage originalImage description
 *  @param size          size description
 *
 *  @return return value description
 */
- (NSData *)pressImageWithImage:(UIImage *)originalImage size:(float)size;

@end
