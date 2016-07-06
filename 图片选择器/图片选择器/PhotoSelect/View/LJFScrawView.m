//
//  LJFScrawView.m
//  照片涂鸦
//
//  Created by Lone on 16/5/21.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "LJFScrawView.h"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

typedef enum : NSUInteger {
    Begin = 0,
    Move,
    End,
} DrawingState;

@interface LJFScrawView()

/**
 *  画图状态
 */
@property (nonatomic) DrawingState drawingState;

@property (nonatomic) CGRect imageRect;

@end

@implementation LJFScrawView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configDate];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configDate];
    }
    return self;
}

- (void)configDate
{
    self.strokeWidth = 8;
    self.strokeColor = [UIColor greenColor];
    self.contentMode = UIViewContentModeScaleToFill;
    self.userInteractionEnabled = YES;
    self.imageRect   = [self getFrameSizeForImage:self.image inImageView:self];
    
}

#pragma mark touches 回调
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    if (self.brush) {
        self.brush.lastPoint = CGPointMake(0, 0);
        self.brush.beginPoint = [[touches anyObject] locationInView:self];
        self.brush.endPoint = self.brush.beginPoint;
        self.drawingState = Begin;
        [self drawingImage];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.brush) {
        self.brush.endPoint = [[touches anyObject] locationInView:self];
        self.drawingState = End;
        [self drawingImage];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.brush) {
        self.brush.endPoint = [[touches anyObject] locationInView:self];
        self.drawingState = Move;
        [self drawingImage];
    }
}

#pragma mark - 画图
- (void)drawingImage
{
    if (self.brush) {
        UIGraphicsBeginImageContext(self.bounds.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.image drawInRect:[self getFrameSizeForImage:self.image inImageView:self]];
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, self.strokeWidth);
        CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor);
        
        if (self.realImage) {
            [self.realImage drawInRect:self.bounds];
        }
        [self.brush drawInContext:context];
        CGContextStrokePath(context);
        
        UIImage *previewImage = UIGraphicsGetImageFromCurrentImageContext();
        if (self.drawingState == End || [self.brush supportedContinuousDrawing]){
            self.realImage = previewImage;
        }
        UIGraphicsEndImageContext();
        self.image = previewImage;
        self.brush.lastPoint = self.brush.endPoint;
    }
}

////裁剪图片
//- (UIImage *)cutImage:(UIImage*)image
//{
//    //压缩图片
//    CGSize newSize;
//    CGImageRef imageRef = nil;
//    
//    if ((image.size.width / image.size.height) < (_headerView.bgImgView.size.width / _headerView.bgImgView.size.height)) {
//        newSize.width = image.size.width;
//        newSize.height = image.size.width * _headerView.bgImgView.size.height / _headerView.bgImgView.size.width;
//        
//        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
//        
//    } else {
//        newSize.height = image.size.height;
//        newSize.width = image.size.height * 3.bgImgView.size.width / _headerView.bgImgView.size.height;
//        
//        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
//        
//    }
//    
//    return [UIImage imageWithCGImage:imageRef];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
