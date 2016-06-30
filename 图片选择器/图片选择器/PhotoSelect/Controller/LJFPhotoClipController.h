//
//  CircularClipView.m
//  MasonryDemo
//
//  Created by Lone on 16/6/30.
//  Copyright © 2016年 Lone. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LJFPhotoClipController;
typedef enum{
    CIRCULARCLIP   = 0,   //圆形裁剪
    SQUARECLIP            //方形裁剪
    
}ClipType;


@interface LJFPhotoClipController : UIViewController<UIGestureRecognizerDelegate>
{
    UIImageView *_imageView;
    UIImage *_image;
    UIView * _overView;
}
@property (nonatomic, assign)CGFloat scaleRation;//图片缩放的最大倍数
@property (nonatomic, assign)CGFloat radius; //圆形裁剪框的半径
@property (nonatomic, assign)CGRect circularFrame;//裁剪框的frame
@property (nonatomic, assign)CGRect originalFrame;
@property (nonatomic, assign)CGRect currentFrame;

@property (nonatomic) CGSize clipSize;

@property (nonatomic, assign)ClipType clipType;  //裁剪的形状

-(instancetype)initWithImage:(UIImage *)image;
@end
