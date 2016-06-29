//
//  LJFBaseBrush.h
//  照片涂鸦
//
//  Created by Lone on 16/5/23.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

/**
 *  画图协议
 */
@protocol LJFPaintBrushDelegate <NSObject>

/**
 *  是否支持连续画图
 *
 *  @return return value description
 */
- (BOOL)supportedContinuousDrawing;

/**
 *  基于Context的绘图方法，子类必须实现具体的绘图
 *
 *  @param context context description
 */
- (void)drawInContext:(CGContextRef)context;

@end

@interface LJFBaseBrush : NSObject<LJFPaintBrushDelegate>

@property (nonatomic) CGPoint beginPoint;           /**<  开始点>*/
@property (nonatomic) CGPoint endPoint;             /**<  结束点>*/
@property (nonatomic) CGPoint lastPoint;            /**<  上一点>*/

@end
