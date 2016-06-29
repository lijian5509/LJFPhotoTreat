//
//  NSObject+ImageRect.m
//  照片涂鸦
//
//  Created by Lone on 16/5/23.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "NSObject+ImageRect.h"

@implementation NSObject (ImageRect)

#pragma mark - 计算image 相对于imageview的比例
- (CGRect)getFrameSizeForImage:(UIImage *)image
                   inImageView:(UIImageView *)imageView {
    /**
     *  计算宽高比例
     */
    float hfactor = image.size.width / imageView.frame.size.width;
    float vfactor = image.size.height / imageView.frame.size.height;
    
    //筛选出最大比例
    float factor = fmax(hfactor, vfactor);
    
    // Divide the size by the greater of the vertical or horizontal shrinkage factor
    float newWidth = image.size.width / factor;
    float newHeight = image.size.height / factor;
    
    // Then figure out if you need to offset it to center vertically or horizontally
    float leftOffset = (imageView.frame.size.width - newWidth) / 2;
    float topOffset = (imageView.frame.size.height - newHeight) / 2;
    
    return CGRectMake(leftOffset, topOffset, newWidth, newHeight);
}

#pragma mark - 计算size
- (CGSize)calculateViewFitSizeWithImage:(UIImage *)image
                              planWidth:(CGFloat)planWidth
                             planHeight:(CGFloat)planHeight
{
    float hfactor = image.size.width / planWidth;
    float vfactor = image.size.height / planHeight;
    //筛选出最大比例
    float factor = fmax(hfactor, vfactor);
    
    // Divide the size by the greater of the vertical or horizontal shrinkage factor
    float newWidth = image.size.width / factor;
    float newHeight = image.size.height / factor;
    return CGSizeMake(newWidth, newHeight);
}

#pragma mark -裁剪照片
- (UIImage *)scaleToSize:(UIImage *)image size:(CGSize)size
{
    //创建一个bitmap的context
    //并把他设置成当前的context
    UIGraphicsBeginImageContext(size);
    //绘制图片的大小
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    //从当前context中创建一个改变大小后的图片
    UIImage *endImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return endImage;
}

#pragma mark -图片截取
- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect{
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}



@end
