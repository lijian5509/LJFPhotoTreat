//
//  LJFPhotoViewCell.m
//  图片选择器
//
//  Created by Lone on 16/6/23.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "LJFPhotoViewCell.h"

@interface LJFPhotoViewCell ()

/**
 *  图片展示图
 */
@property (nonatomic, strong)UIImageView *photoImageView;

@end

@implementation LJFPhotoViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.photoImageView];
        [self.contentView addSubview:self.selectBtn];
    }
    return self;
}

- (UIButton *)selectBtn
{
    if (!_iconBtn) {
        CGFloat width = (30*3/280.0) * CGRectGetWidth(self.frame);
        _iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _iconBtn.frame = CGRectMake(CGRectGetWidth(self.frame) - width, 0, width, width);
        [_iconBtn setBackgroundImage:[UIImage imageNamed:@"select_s"] forState:UIControlStateNormal];
        [_iconBtn setBackgroundImage:[UIImage imageNamed:@"select_n"] forState:UIControlStateSelected];
        [_iconBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _iconBtn;
}

- (UIImageView *)photoImageView
{
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc]initWithFrame:self.contentView.frame];
    }
    return _photoImageView;
}

- (void)btnClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        if ([self.delegate respondsToSelector:@selector(LJFPhotoViewCell:PhotoSelectStateChanged:)]) {
            [self.delegate LJFPhotoViewCell:self PhotoSelectStateChanged:YES];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(LJFPhotoViewCell:PhotoSelectStateChanged:)]) {
            [self.delegate LJFPhotoViewCell:self PhotoSelectStateChanged:NO];
        }
    }
}

- (void)setAssetModel:(LJFAssetModel *)assetModel
{
    _assetModel = assetModel;
    self.photoImageView.image = assetModel.thumbnail;
}

@end

