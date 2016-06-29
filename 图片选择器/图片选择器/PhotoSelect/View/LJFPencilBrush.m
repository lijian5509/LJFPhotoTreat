//
//  LJFPencilBrush.m
//  照片涂鸦
//
//  Created by Lone on 16/5/23.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "LJFPencilBrush.h"

@implementation LJFPencilBrush

- (BOOL)supportedContinuousDrawing
{
    return YES;
}

- (void)drawInContext:(CGContextRef)context
{
    if (self.lastPoint.x > 0) {
        CGContextMoveToPoint(context, self.lastPoint.x, self.lastPoint.y);
        CGContextAddLineToPoint(context, self.endPoint.x, self.endPoint.y);
    }else{
        CGContextMoveToPoint(context, self.beginPoint.x, self.beginPoint.y);
        CGContextAddLineToPoint(context, self.endPoint.x, self.endPoint.y);
    }
}

@end
