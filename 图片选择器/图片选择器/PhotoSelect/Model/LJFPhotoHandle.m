//
//  LJFPhotoHandle.m
//  图片选择器
//
//  Created by Lone on 16/6/21.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "LJFPhotoHandle.h"

@interface LJFPhotoHandle ()

@property (nonatomic, strong)ALAssetsLibrary *assetLibrary;

@end

@implementation LJFPhotoHandle

#pragma mark - 单例
+ (instancetype)shareInstance
{
    static LJFPhotoHandle *photoHandle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        photoHandle = [[LJFPhotoHandle alloc] init];
        photoHandle.assetLibrary = [[ALAssetsLibrary alloc] init];
    });
    return photoHandle;
}

#pragma mark - 获取指定类型相册
- (void)ljf_getAlbumsWithAlbumType:(LJFGetAlbumsType)albumsType
                           success:(void (^)(NSArray<LJFAssetsGroupModel *> *))successBlock
                              fail:(void (^)(NSError *))failBlock
{
    NSArray *assetsFilter = @[[ALAssetsFilter allAssets],
                              [ALAssetsFilter allPhotos],
                              [ALAssetsFilter allVideos]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getAlbumsWithAssetsFilter:assetsFilter[albumsType]
                                success:successBlock
                                   fail:failBlock];
    });
}

#pragma mark - 获取所有图片资源
- (void)ljf_getAllPhotosWithAssetesGroup:(ALAssetsGroup *)assetesGroup
                               assetType:(LJFAssetType)assetType
                                 success:(void (^)(NSArray<LJFAssetModel *> *))successBlock
                                    fail:(void (^)(NSError *))failBlock
{
    NSArray *assetTypes = @[@"",
                            ALAssetTypePhoto,
                            ALAssetTypeVideo];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getAllPhotosWithAssetesGroup:assetesGroup
                                 assetType:assetTypes[assetType]
                                   success:successBlock
                                      fail:failBlock];
    });
    
}

#pragma mark - 获取相册
- (void)getAlbumsWithAssetsFilter:(ALAssetsFilter *)assetFilter
                          success:(void (^)(NSArray<LJFAssetsGroupModel *> *))successBlock
                             fail:(void (^)(NSError *))failBlock
{
    NSMutableArray *dataArray = [NSMutableArray new];
    [self.assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                     usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                         if (assetFilter != nil) {
                                             [group setAssetsFilter:assetFilter];
                                         }
                                         if (group) {
                                             if ([group numberOfAssets] > 0) {
                                                 [dataArray addObject:[[LJFAssetsGroupModel alloc] initWithAssetsGroup:group]];
                                             }
                                         }else {
                                             *stop = YES;
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 successBlock(dataArray);
                                             });
                                         }
                                     } failureBlock:^(NSError *error) {
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             failBlock(error);
                                         });
                                     }];
}

#pragma mark - 根据相册获取相册下的资源
- (void)getAllPhotosWithAssetesGroup:(ALAssetsGroup *)assetesGroup
                           assetType:(NSString *)assetType
                             success:(void (^)(NSArray<LJFAssetModel *> *))successBlock
                                fail:(void (^)(NSError *))failBlock
{
    NSMutableArray *dataArray = [NSMutableArray new];
    [assetesGroup enumerateAssetsWithOptions:NSEnumerationReverse
                                  usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                      if (result) {
                                          NSString *propertyType = [result valueForProperty:ALAssetPropertyType];
                                          if ([propertyType isEqualToString:assetType] || assetType.length == 0) {
                                              [dataArray addObject:[[LJFAssetModel alloc] initWithAsset:result]];
                                          }
                                      }else {
                                          *stop = YES;
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              successBlock(dataArray);
                                          });
                                      }
                                  }];
    
}

@end
