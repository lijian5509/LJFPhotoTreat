//
//  LJFPhotoCompose.m
//  图片选择器
//
//  Created by Lone on 16/7/8.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "LJFPhotoCompose.h"

static CGFloat const boardViewHeight = 300;     /**<画板高度>*/
static CGFloat const boardViewWidth  = 300;     /**<画板宽度>*/

@interface LJFPhotoCompose()

@property (nonatomic, strong) NSMutableArray *imagesArray;

@end

@implementation LJFPhotoCompose

+ (instancetype)initWithImagesArray:(NSArray *)imagsArray
                           finished:(void (^)(UIImage *))finish
                         targetSize:(CGSize)targetSize
                     boardViewColor:(UIColor *)boardViewColor
{
    LJFPhotoCompose *photo = [[LJFPhotoCompose alloc] init];
    finish([photo makeImageWithImagesArray:imagsArray
                                targetSzie:targetSize
                            boardViewColor:boardViewColor]);
    return photo;
}

#pragma mark - 制作图片
- (UIImage *)makeImageWithImagesArray:(NSArray *)imagesArray
                           targetSzie:(CGSize)targetSize
                       boardViewColor:(UIColor *)boardViewColor
{
    if (!imagesArray && imagesArray.count == 0) {
        return nil;
    }
    NSArray *positionArray = [self getPositionsSiteWithImagesCount:imagesArray.count];
    UIView *groupAvatarView = [[UIView alloc]initWithFrame:CGRectMake(0,0,boardViewHeight,boardViewWidth)];
    if (boardViewColor) {
        groupAvatarView.backgroundColor = boardViewColor;
    }
    
    for (int i = 0; i < [imagesArray count]; i++){
        UIImageView *tempImageView;
        if ([imagesArray count] < 5){
            tempImageView = [[UIImageView alloc]initWithFrame:[positionArray[i] CGRectValue]];
        }
        else{
            tempImageView = [[UIImageView alloc]initWithFrame:[positionArray[i] CGRectValue]];
        }
        [tempImageView setImage:[imagesArray objectAtIndex:i]];
        [groupAvatarView addSubview:tempImageView];
    }
    
    if (targetSize.width == 0) {
        targetSize = CGSizeMake(60, 60);
    }
    UIImage *reImage = [self drawImageToSize:[self convertViewToImage:groupAvatarView]size:targetSize];
    
    return reImage;
}

#pragma Mark - 获取图片左边点数组
- (NSArray *)getPositionsSiteWithImagesCount:(NSInteger)count
{
    NSMutableArray *positions = [NSMutableArray new];
    CGFloat itemWidth;
    CGFloat itemHeight;
    NSInteger linesNumber;
    if (count < 5) {//两行两列
        linesNumber = 2;
    }else{
        linesNumber = 3;
    }
    itemWidth = boardViewWidth/linesNumber;
    itemHeight = boardViewHeight/linesNumber;
    
    for (int i= 0; i < count; i ++ ) {
        CGFloat pointX = i % linesNumber * itemWidth;
        CGFloat pointY = i / linesNumber * itemHeight;
        [positions addObject:[NSValue valueWithCGRect:CGRectMake(pointX, pointY, itemWidth, itemHeight)]];
    }
    return positions;
}

#pragma mark - 截图
-(UIImage*)convertViewToImage:(UIView*)view{
    
    CGSize s = view.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数。
    UIGraphicsBeginImageContextWithOptions(s, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}

#pragma mark - 图片绘制
- (UIImage *)drawImageToSize:(UIImage *)image size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

@end
