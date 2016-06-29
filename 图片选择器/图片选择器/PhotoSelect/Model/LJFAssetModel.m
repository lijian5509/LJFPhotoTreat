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
        self.assetPropertyType                = [asset valueForProperty:ALAssetPropertyType];
        self.assetPropertyLocation            = [asset valueForProperty:ALAssetPropertyLocation];
        self.assetPropertyDate                = [asset valueForProperty:ALAssetPropertyDate];
        self.assetPropertyDuration            = [asset valueForProperty:ALAssetPropertyDuration];
        self.thumbnail                        = [UIImage imageWithCGImage:[asset thumbnail]];
        self.representation                   = [asset defaultRepresentation];
        self.dimension                        = [self.representation dimensions];
        
//        CGImageRelease([representation fullScreenImage]);
//        CGImageRelease([asset thumbnail]);
//        CGImageRef cgimage = [representation fullScreenImage];
//        self.fullScreenImage                  = [UIImage imageWithCGImage:cgimage];
//        CGImageRelease(cgimage);
//        self.fullResolutionImage              = [UIImage imageWithCGImage:[representation fullResolutionImage]];
        self.filename                         = [self.representation filename];
        self.scale                            = [self.representation scale];
        self.size                             = [self.representation size];
        self.metadata                         = [self.representation metadata];
        self.orientation                      = [self.representation orientation];
        self.url                              = [self.representation url];
        self.UTI                              = [self.representation UTI];
    }
    return self;
}

@end
