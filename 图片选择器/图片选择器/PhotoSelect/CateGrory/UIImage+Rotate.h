//
//  UIImage+Rotate.h
//  图片选择器
//
//  Created by Lone on 16/7/6.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Rotate)
/*
 * @brief rotate image 90 withClockWise 顺时针
 */
- (UIImage *)rotate90Clockwise;

/*
 * @brief rotate image 90 counterClockwise 逆时针
 */
- (UIImage *)rotate90CounterClockwise;

/*
 * @brief rotate image 180 degree   180°旋转
 */
- (UIImage *)rotate180;

/*
 * @brief rotate image to default orientation
 */
- (UIImage *)rotateImageToOrientationUp;

/*
 * @brief flip horizontal   水平翻转
 */
- (UIImage *)flipHorizontal;

/*
 * @brief flip vertical     垂直翻转
 */
- (UIImage *)flipVertical;

/*
 * @brief flip horizontal and vertical
 */
- (UIImage *)flipAll;

@end
