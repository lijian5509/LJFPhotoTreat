//
//  ViewController.h
//  图片选择器
//
//  Created by Lone on 16/6/21.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoSelectController : UIViewController

- (IBAction)btnClicked:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

