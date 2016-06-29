//
//  LJFAssetsGroupModel.h
//  图片选择器
//
//  Created by Lone on 16/6/21.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJFAssetsGroupModel : NSObject

- (instancetype)initWithAssetsGroup:(ALAssetsGroup *)assetsGroup;

@property (nonatomic, strong)   ALAssetsGroup *assetsGroup;

@property (nonatomic, copy)     NSString *assetsName;               /**<  资源集名称>*/
@property (nonatomic)           NSInteger assetsNumbers;            /**<  资源集-资源数量>*/
@property (nonatomic, strong)   UIImage *posterImage;               /**<  封面图片>*/

@end
