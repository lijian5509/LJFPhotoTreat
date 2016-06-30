//
//  LJFPhotoPickerController.h
//  图片选择器
//
//  Created by Lone on 16/6/24.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectFinishBlcok)(NSArray <LJFAssetModel *> *resultArray);
typedef void(^SingleSelectFinishBlcok)(UIImage *image);

@interface LJFPhotoPickerController : UINavigationController


/**
 *  单选初始化方法
 *
 *  @param finishBlock finishBlock description
 *
 *  @return return value description
 */
- (instancetype)initWithBlocSingleSelect:(void(^)(UIImage *image))finishBlock;

/**
 *  多选初始化方法
 *
 *  @param finishBlock finishBlock description
 *  @param singleImage    单选模式
 *
 *  @return return value description
 */
- (instancetype)initWithBlock:(void(^)(NSArray <LJFAssetModel *> *resultArray))finishBlock;

/**
 *  设置导航栏颜色
 */
@property (nonatomic, strong) UIColor *navGationBarColor;

/**
 *  是否支持多选 默认为no
 */
@property (nonatomic) BOOL isSupportMultipleSelect;
/**
 *  多选回调block
 */
@property (nonatomic, copy)SelectFinishBlcok finishBlock;

/**
 *  单选回调block
 */
@property (nonatomic, copy)SingleSelectFinishBlcok singleFinishBlock;

@end
