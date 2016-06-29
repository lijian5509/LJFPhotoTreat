//
//  LJFAssetModel.h
//  图片选择器
//
//  Created by Lone on 16/6/21.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface LJFAssetModel : NSObject

- (instancetype)initWithAsset:(ALAsset *)asset;

@property (nonatomic, strong)   ALAsset *asset;

@property (nonatomic, copy)     NSString *assetPropertyType;                /**< 资源类型ALAssetTypePhoto, ALAssetTypeVideo or ALAssetTypeUnknown> */
@property (nonatomic, copy)     NSString *assetPropertyLocation;            /**< 资源位置> */
@property (nonatomic, copy)     NSString *assetPropertyDuration;            /**< 视频时间> */
@property (nonatomic, copy)     NSString *assetPropertyDate;                /**< 拍摄时间> */
@property (nonatomic, strong)   UIImage *fullResolutionImage;               /**< 高清图> */
@property (nonatomic, strong)   UIImage *fullScreenImage;                   /**< 全屏图> */
@property (nonatomic, strong)   UIImage *thumbnail;                         /**< 缩略图> */
@property (nonatomic, strong)   NSDictionary *metadata;                     /**< 缩放倍数> */
@property (nonatomic, strong)   NSURL *url;                                 /**< 图片路径> */
@property (nonatomic, copy)     NSString *UTI;                              /**< 资源图片uti，唯一标示符> */
@property (nonatomic, copy)     NSString *filename;                         /**< 获取资源图片的名字> */
@property (nonatomic)           float scale;                                /**< 缩放倍数> */
@property (nonatomic)           long long size;                             /**< 图片资源容量大小> */
@property (nonatomic)           ALAssetOrientation orientation;             /**< 旋转方向> */
@property (nonatomic)           CGSize dimension;                           /**< 获取资源图片的长宽> */
@property (nonatomic, strong)   ALAssetRepresentation *representation;


@end
