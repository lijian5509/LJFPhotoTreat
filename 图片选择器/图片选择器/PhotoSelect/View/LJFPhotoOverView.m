//
//  LJFPhotoOverView.m
//  图片选择器
//
//  Created by Lone on 16/6/24.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "LJFPhotoOverView.h"

@implementation LJFPhotoOverView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)cancel:(id)sender {
    [self.pickerControl dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)takePhoto:(id)sender {
    [self.pickerControl takePicture];
    [self.backImageView removeFromSuperview];
}
@end
