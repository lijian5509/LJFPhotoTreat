//
//  LJFAssetsGroupModel.m
//  图片选择器
//
//  Created by Lone on 16/6/21.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "LJFAssetsGroupModel.h"

@implementation LJFAssetsGroupModel

- (instancetype)initWithAssetsGroup:(ALAssetsGroup *)assetsGroup
{
    self = [super init];
    if (self) {
        self.assetsGroup   = assetsGroup;
        self.assetsName    = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
        self.posterImage   = [UIImage imageWithCGImage:assetsGroup.posterImage];
        self.assetsNumbers = [assetsGroup numberOfAssets];
    }
    return  self;
}

@end
