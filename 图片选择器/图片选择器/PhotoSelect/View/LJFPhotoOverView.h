//
//  LJFPhotoOverView.h
//  图片选择器
//
//  Created by Lone on 16/6/24.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJFPhotoOverView : UIView
- (IBAction)cancel:(id)sender;
- (IBAction)takePhoto:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (nonatomic, strong) UIImagePickerController *pickerControl;

@end
