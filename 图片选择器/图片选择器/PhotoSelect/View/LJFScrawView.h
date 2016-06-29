//
//  LJFScrawView.h
//  照片涂鸦
//
//  Created by Lone on 16/5/21.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJFBaseBrush.h"

@interface LJFScrawView : UIImageView


@property (nonatomic) CGFloat strokeWidth;              /** <画笔宽度> */

@property (nonatomic, strong) UIColor *strokeColor;     /** <画笔颜色> */

@property (nonatomic, strong) LJFBaseBrush *brush;      /** <画笔> */

/**
 *  image
 */
@property (nonatomic, strong) UIImage *realImage;

@end
