//
//  ViewController.m
//  图片选择器
//
//  Created by Lone on 16/6/21.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PhotoSelectController.h"
#import "LJFPhotoClipController.h"

@interface PhotoSelectController ()
{
    UIImage *_originalImage;
}

@end

@implementation PhotoSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:tap];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    if (_originalImage) {
        LJFPhotoClipController *VC = [[LJFPhotoClipController alloc] initWithImage:_originalImage rusult:^(UIImage *image) {
            _originalImage = image;
            self.imageView.image = _originalImage;
        }];
        [self.navigationController pushViewController:VC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClicked:(UIButton *)sender {
    
    if (sender.tag == 101) {
        LJFPhotoPickerController *VC = [[LJFPhotoPickerController alloc] initWithBlock:^(NSArray<LJFAssetModel *> *resultArray) {
            self.title = [NSString stringWithFormat:@"已选择%ld张照片",resultArray.count];
            NSMutableArray *imagesArray = [NSMutableArray new];
            for (int i = 0; i < resultArray.count; i ++ ) {
                LJFAssetModel *model = resultArray[i];
                UIImage *image = [UIImage imageWithCGImage:[model.representation fullScreenImage]];
                _originalImage = image;
                [imagesArray addObject:image];
            }
            
            /**
             *  图片雅俗对减小图片大小是有效的
             *
             *  @param 320 320 description
             *  @param 240
             *
             *  @return return value description
             */
            [LJFPhotoCompose initWithImagesArray:imagesArray finished:^(UIImage *image) {
                self.imageView.image = image;
            } targetSize:CGSizeMake(320, 240) boardViewColor:[UIColor lightGrayColor]];
        }];
        [self presentViewController:VC animated:YES completion:nil];
    }else{
        LJFPhotoPickerController *VC = [[LJFPhotoPickerController alloc] initWithBlocSingleSelect:^(UIImage *image) {
            _originalImage = image;
            self.imageView.image = image;
            self.title = @"单选";
        }];
        [self presentViewController:VC animated:YES completion:nil];
    }
}


- (IBAction)leftRotation90:(UIBarButtonItem *)sender {
    _originalImage = [_originalImage rotate90CounterClockwise];
    self.imageView.image = _originalImage;
}

- (IBAction)rightRotation90:(id)sender {
    _originalImage = [_originalImage rotate90Clockwise];
    self.imageView.image = _originalImage;
}
@end
