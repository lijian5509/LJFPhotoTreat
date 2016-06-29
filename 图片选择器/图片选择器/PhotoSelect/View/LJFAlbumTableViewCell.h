//
//  LJFAlbumTableViewCell.h
//  CarWins_YD
//
//  Created by Lone on 16/6/27.
//  Copyright © 2016年 CarWins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJFAlbumTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;

@end
