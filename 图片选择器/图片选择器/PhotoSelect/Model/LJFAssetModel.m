//
//  LJFAssetModel.m
//  图片选择器
//
//  Created by Lone on 16/6/21.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "LJFAssetModel.h"

@implementation LJFAssetModel

- (instancetype)initWithAsset:(ALAsset *)asset
{
    self = [super init];
    if (self && asset) {
        self.asset                            = asset;
    }
    return self;
}

- (NSString *)UTI
{
    if (self.representation) {
        return [self.representation UTI];
    }
    return nil;
}

- (NSURL *)url
{
    if (self.representation) {
        return [self.representation url];
    }
    return nil;
}

- (ALAssetOrientation)orientation
{
    if (self.representation) {
        return [self.representation orientation];
    }
    return ALAssetOrientationUp;
}

- (NSDictionary *)metadata
{
    if (self.representation) {
        return [self.representation metadata];
    }
    return nil;
}

- (long long)size
{
    if (self.representation) {
        return [self.representation size];
    }
    return 0;
}

- (float)scale
{
    if (self.representation) {
        return [self.representation scale];
    }
    return 0;
}

- (NSString *)filename
{
    if (self.representation) {
        return [self.representation filename];
    }
    return nil;
}

- (CGSize)dimension
{
    if (self.representation) {
        return [self.representation dimensions];
    }
    return CGSizeZero;
}

-(UIImage *)fullResolutionImage
{
    if (self.representation) {
        return [UIImage imageWithCGImage:[self.representation fullResolutionImage]];
    }
    return nil;
}

- (UIImage *)fullScreenImage
{
    if (self.representation) {
        return [UIImage imageWithCGImage:[self.representation fullScreenImage]];
    }
    return nil;
}

- (NSString *)assetPropertyType
{
    if (self.asset) {
        return  [self.asset valueForProperty:ALAssetPropertyType];
    }
    return nil;
}

- (NSString *)assetPropertyLocation
{
    if (self.asset) {
        return  [self.asset valueForProperty:ALAssetPropertyLocation];
    }
    return nil;
}

- (NSString *)assetPropertyDate
{
    if (self.asset) {
        return  [self.asset valueForProperty:ALAssetPropertyDate];
    }
    return nil;
}

- (NSString *)assetPropertyDuration
{
    if (self.asset) {
        return  [self.asset valueForProperty:ALAssetPropertyDuration];
    }
    return nil;
}

- (UIImage *)thumbnail
{
    if (self.asset) {
        return  [UIImage imageWithCGImage:[self.asset thumbnail]];
    }
    return nil;
}

- (ALAssetRepresentation *)representation
{
    if (self.asset) {
        return  [self.asset defaultRepresentation];
    }
    return nil;
}

@end
