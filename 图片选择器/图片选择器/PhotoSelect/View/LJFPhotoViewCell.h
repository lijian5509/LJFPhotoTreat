//
//  LJFPhotoViewCell.h
//  图片选择器
//
//  Created by Lone on 16/6/23.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LJFPhotoViewCell;

@protocol LJFPhotoViewCellDelegate <NSObject>
/**
 *  图片选中状态发生了改变
 *
 *  @param photoCell 当前cell
 *  @param selected  选中状态
 */
- (void)LJFPhotoViewCell:(LJFPhotoViewCell *)photoCell PhotoSelectStateChanged:(BOOL)selected;

@end

@interface LJFPhotoViewCell : UICollectionViewCell

@property (nonatomic, strong)   LJFAssetModel *assetModel;                                  /** <照片模型>*/
@property (nonatomic, weak)     id<LJFPhotoViewCellDelegate>delegate;                       /** <代理>*/

/**
 *  选中表示图
 */
@property (nonatomic, strong)UIButton *iconBtn;

@end
