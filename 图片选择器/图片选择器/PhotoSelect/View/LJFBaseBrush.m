//
//  LJFBaseBrush.m
//  照片涂鸦
//
//  Created by Lone on 16/5/23.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "LJFBaseBrush.h"

@implementation LJFBaseBrush

- (BOOL)supportedContinuousDrawing
{
    return false;
}

- (void)drawInContext:(CGContextRef)context
{
    NSAssert(false, @"子类重写实现此方法");
}

@end
