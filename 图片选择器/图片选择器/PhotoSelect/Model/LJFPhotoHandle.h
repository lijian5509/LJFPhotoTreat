//
//  LJFPhotoHandle.h
//  图片选择器
//
//  Created by Lone on 16/6/21.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    LJFGetAllAlbums = 0,   /**<所有相册>*/
    LJFGetPhotoAlbums,     /**<图片相册>*/
    LJFGetVidioAlbums,     /**<视频相册>*/
} LJFGetAlbumsType;

typedef enum : NSUInteger {
    LJFPhotoTypeAll = 0,   /**<所有资源>*/
    LJFPhotoTypePhoto,     /**<图片资源>*/
    LJFPhotoTypeVidio,     /**<视频资源>*/
} LJFAssetType;

@interface LJFPhotoHandle : NSObject

/**
 *  单例模式
 *
 *  @return 类对象
 */
+ (instancetype)shareInstance;

/**
 *  获取相册
 *
 *  @param albumsType   相册类型
 *  @param successBlock successBlock description
 *  @param failBlock    failBlock description
 */
- (void)ljf_getAlbumsWithAlbumType:(LJFGetAlbumsType)albumsType
                           success:(void(^)(NSArray<LJFAssetsGroupModel *> *alblums))successBlock
                              fail:(void(^)(NSError *error))failBlock;
/**
 *  获取指定相册目录下的资源文件
 *
 *  @param assetesGroup 相册
 *  @param assetType    资源类型
 *  @param successBlock 成功回调
 *  @param failBlock    失败回调
 */
- (void)ljf_getAllPhotosWithAssetesGroup:(ALAssetsGroup *)assetesGroup
                               assetType:(LJFAssetType)assetType
                                 success:(void(^)(NSArray<LJFAssetModel *> *alblums))successBlock
                                    fail:(void(^)(NSError *error))failBlock;

/**
 *  扩充
 1.ALAssetsGroup 相册
 2.valueForProperty 方法 查看相册属性，如 ALAssetsGroupPropertyName 相册名
 3.posterImage方法就是相册的封面图片
 4.numberOfAssets方法获取该相册的图片视频数量
 */

/**
 *  扩充
 1.ALAsset 相册资源
 2.valueForProperty 方法 查看相册属性，如 ALAssetPropertyType 三种类型ALAssetTypePhoto, ALAssetTypeVideo or ALAssetTypeUnknown
 3.ALAssetPropertyLocation 照片位置
 4.ALAssetPropertyDuration 视频时间
 5.ALAssetPropertyDate 拍摄日期
 6. defaultRepresentation 返回值是ALAssetRepresentation类，该类的作用就是获取该资源图片的详细资源信息。
 //获取资源图片的详细资源信息
 ALAssetRepresentation* representation = [asset defaultRepresentation];
 //获取资源图片的长宽
 CGSize dimension = [representation dimensions];
 //获取资源图片的高清图
 [representation fullResolutionImage];
 //获取资源图片的全屏图
 [representation fullScreenImage];
 //获取资源图片的名字
 NSString* filename = [representation filename];
 NSLog(@"filename:%@",filename);
 //缩放倍数
 [representation scale];
 //图片资源容量大小
 [representation size];
 //图片资源原数据
 [representation metadata];
 //旋转方向
 [representation orientation];
 //资源图片url地址，该地址和ALAsset通过ALAssetPropertyAssetURL获取的url地址是一样的
 NSURL* url = [representation url];
 NSLog(@"url:%@",url);
 //资源图片uti，唯一标示符
 NSLog(@"uti:%@",[representation UTI]);
 */


@end
