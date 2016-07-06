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
    }
    return  self;
}

- (NSString *)assetsName
{
    if (self.assetsGroup) {
        return [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    }
    return nil;
}

- (UIImage *)posterImage
{
    if (self.assetsGroup) {
        return [UIImage imageWithCGImage:self.assetsGroup.posterImage];
    }
    return nil;
}

- (NSInteger)assetsNumbers
{
    if (self.assetsGroup) {
        return [self.assetsGroup numberOfAssets];
    }
    return 0;
}

@end
