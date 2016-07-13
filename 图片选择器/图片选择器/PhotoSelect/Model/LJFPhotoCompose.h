//
//  LJFPhotoCompose.h
//  图片选择器
//
//  Created by Lone on 16/7/8.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  图片合成
 */
@interface LJFPhotoCompose : NSObject

/**
 *  初始化方法
 *
 *  @param imagsArray imagsArray description
 *
 *  @return return value description
 */
+ (instancetype)initWithImagesArray:(NSArray *)imagsArray
                           finished:(void(^)(UIImage *image))finish
                         targetSize:(CGSize)targetSize
                     boardViewColor:(UIColor *)boardViewColor;

@end
