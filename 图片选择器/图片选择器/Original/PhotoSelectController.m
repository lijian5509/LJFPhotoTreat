//
//  ViewController.m
//  图片选择器
//
//  Created by Lone on 16/6/21.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PhotoSelectController.h"

@interface PhotoSelectController ()

@end

@implementation PhotoSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClicked:(UIButton *)sender {
    
    if (sender.tag == 101) {
        LJFPhotoPickerController *VC = [[LJFPhotoPickerController alloc] initWithBlock:^(NSArray<LJFAssetModel *> *resultArray) {
            self.title = [NSString stringWithFormat:@"已选择%ld张照片",resultArray.count];
            LJFAssetModel *model = [resultArray firstObject];
            UIImage *image = [UIImage imageWithCGImage:[model.representation fullScreenImage]];
            /**
             *  图片雅俗对减小图片大小是有效的
             *
             *  @param 320 320 description
             *  @param 240
             *
             *  @return return value description
             */
            self.imageView.image = [image drawImageWithBackColor:[UIColor blackColor] targetSize:CGSizeMake(320, 240)];
        }];
        [self presentViewController:VC animated:YES completion:nil];
    }else{
        LJFPhotoPickerController *VC = [[LJFPhotoPickerController alloc] initWithBlocSingleSelect:^(UIImage *image) {
            self.imageView.image = image;
            self.title = @"单选";
        }];
        [self presentViewController:VC animated:YES completion:nil];
    }
}
@end
