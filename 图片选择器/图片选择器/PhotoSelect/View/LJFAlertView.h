//
//  LJFAlertView.h
//  AlertView
//
//  Created by hezhijingwei on 16/7/15.
//  Copyright © 2016年 lone. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    AlertContenAligmentLeft = 0,
    AlertContenAligmentCenter,
    AlertContenAligmentRight,
} AlertContenAligment;

typedef void(^defaultBtnClicked)(UIButton *defaultBtn);
typedef void(^cancelBtnClicked)(UIButton *cancelBtn);

@interface LJFAlertView : UIView

/**
 *  初始化方法
 *
 *  @param title       标题
 *  @param text        message
 *  @param sure        操作
 *  @param cancel      取消
 *  @param sureBlock   操作回调
 *  @param cancelBlock 取消回调
 *
 *  @return return value description
 */
+ (instancetype)initWithAlertViewWithTitle:(NSString *)title
                                      text:(NSString *)text
                                      sure:(NSString *)sure
                                    cancel:(NSString *)cancel
                              sureBtnBlock:(defaultBtnClicked)sureBlock
                            cancelBtnBlock:(cancelBtnClicked)cancelBlock;

- (instancetype)initWithAlertViewWithTitle:(NSString *)title
                                      text:(NSString *)text
                                      sure:(NSString *)sure
                                    cancel:(NSString *)cancel
                              sureBtnBlock:(defaultBtnClicked)sureBlock
                            cancelBtnBlock:(cancelBtnClicked)cancelBlock;

- (void)show;

/**
 *  内容对其方式 默认左对齐
 */
@property (nonatomic) AlertContenAligment textAligment;
@property (nonatomic ,strong) UIButton *cancelButton;       /**<取消按钮>*/
@property (nonatomic ,strong) UIButton *defaultButton;      /**<操作按钮>*/

@end
