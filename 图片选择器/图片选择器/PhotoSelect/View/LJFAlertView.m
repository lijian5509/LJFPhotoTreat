//
//  LJFAlertView.m
//  AlertView
//
//  Created by lone on 16/7/15.
//  Copyright © 2016年 lone. All rights reserved.
//

#import "LJFAlertView.h"

#define CLCUSTOMSCREEN_FRAME [UIScreen mainScreen].bounds
#define CLCUSTOMSCREEN_SIZE [UIScreen mainScreen].bounds.size
#define CLCUSTOMSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define CLCUSTOMSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface LJFAlertView ()
@property (nonatomic ,strong) UIView *contentView;
@property (nonatomic ,strong) NSString *text;
@property (nonatomic ,strong) NSString *title;
@property (nonatomic ,copy) defaultBtnClicked defaultBtnBlock;
@property (nonatomic ,copy) cancelBtnClicked cancelBtnBlock;

@end

@implementation LJFAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CLCUSTOMSCREEN_FRAME];
    if (self) {
        [self setupUI];
    }
    return self;
}

+ (instancetype)initWithAlertViewWithTitle:(NSString *)title text:(NSString *)text sure:(NSString *)sure cancel:(NSString *)cancel sureBtnBlock:(defaultBtnClicked)sureBlock cancelBtnBlock:(cancelBtnClicked)cancelBlock
{
    LJFAlertView * alert = [[LJFAlertView alloc] initWithAlertViewWithTitle:title text:text sure:sure cancel:cancel sureBtnBlock:sureBlock cancelBtnBlock:cancelBlock];
    [alert show];
    return alert;
}

- (instancetype)initWithAlertViewWithTitle:(NSString *)title text:(NSString *)text sure:(NSString *)sure cancel:(NSString *)cancel sureBtnBlock:(defaultBtnClicked)sureBlock cancelBtnBlock:(cancelBtnClicked)cancelBlock
{
    self = [super init];
    if (self) {
        
        self.title           = title;
        self.text            = text;
        self.cancelBtnBlock  = cancelBlock;
        self.defaultBtnBlock = sureBlock;
        [self.defaultButton setTitle:sure forState:UIControlStateNormal];
        [self.cancelButton  setTitle:cancel forState:UIControlStateNormal];
        [self setupUI];
    }
    return self;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
         _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
         [_cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)defaultButton
{
    if (!_defaultButton) {
        _defaultButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_defaultButton addTarget:self action:@selector(defaultBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_defaultButton setTitleColor:kCWTextRedColor forState:UIControlStateNormal];
    }
    return _defaultButton;
}

#pragma mark - setUI
- (void)setupUI {
    
    self.backgroundColor = [UIColor clearColor];
    self.frame = CLCUSTOMSCREEN_FRAME;
    
    UIView *bgView = [[UIView alloc] initWithFrame:self.frame];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.1;
    [self addSubview:bgView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:view];
    view.center = self.center;
    view.backgroundColor = [UIColor whiteColor];
    
    view.frame = CGRectMake(self.frame.size.width/2.0 , -10, 240.0/320*CLCUSTOMSCREEN_WIDTH, 10);
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 10;
    self.contentView = view;
    
}

#pragma mark - 创建弹窗
- (void)alertViewWithTitle:(NSString *)title
                      text:(NSString *)text{
    
    UILabel *label      = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, self.contentView.frame.size.width - 20, 20)];
    label.font          = [UIFont systemFontOfSize:19];
    label.text          = title;
    label.textColor     = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:label];
    
    UILabel *textLabel      = [[UILabel alloc] init];
    textLabel.text          = text;
    textLabel.numberOfLines = 0;
    textLabel.textColor     = [UIColor grayColor];
    textLabel.font          = [UIFont systemFontOfSize:16];
    textLabel.adjustsFontSizeToFitWidth = YES;
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    //写在这个中间的代码,都不会被编译器提示-Wdeprecated-declarations类型的警告
    CGSize size             = [text sizeWithFont:[UIFont systemFontOfSize:16]
                               constrainedToSize:CGSizeMake(self.contentView.frame.size.width - 40, 400)
                                   lineBreakMode:NSLineBreakByWordWrapping|NSLineBreakByCharWrapping];
#pragma clang diagnostic pop
    
    textLabel.textAlignment = (NSInteger)self.textAligment;
    
    if (size.height > 50 && size.height <= 200) {
        textLabel.frame = CGRectMake(20, CGRectGetMaxY(label.frame) + 8, self.contentView.frame.size.width - 40, size.height);
    } else if (size.height <= 50){
        textLabel.frame = CGRectMake(20, CGRectGetMaxY(label.frame) + 8, self.contentView.frame.size.width - 40, 50);
    } else {
        textLabel.frame = CGRectMake(20, CGRectGetMaxY(label.frame) + 8, self.contentView.frame.size.width - 40, 200);
    }
    
    [self.contentView addSubview:textLabel];
    
    UIView *Hview          = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(textLabel.frame)+8, self.contentView.frame.size.width, 1)];
    Hview.backgroundColor  = [UIColor colorWithWhite:0.7 alpha:1];
    [self.contentView addSubview:Hview];
    
   
    [self.contentView addSubview:self.cancelButton];
    self.cancelButton.frame     = CGRectMake(10, CGRectGetMaxY(Hview.frame), (self.contentView.frame.size.width - 20)/2.0, 44);
    
    [self.contentView addSubview:self.defaultButton];
    self.defaultButton.frame    = CGRectMake(CGRectGetMaxX(self.cancelButton.frame), CGRectGetMaxY(Hview.frame), (self.contentView.frame.size.width - 20)/2.0, 44);
    
    UIView *Vview           = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cancelButton.frame)-0.5, CGRectGetMaxY(textLabel.frame)+8, 1, 44)];
    Vview.backgroundColor   = [UIColor colorWithWhite:0.7 alpha:1];
    [self.contentView addSubview:Vview];
    
    self.contentView.frame  = CGRectMake(self.center.x - 120.0/320*CLCUSTOMSCREEN_WIDTH , self.center.y - CGRectGetMaxY(self.defaultButton.frame)/2.0, 240.0/320*CLCUSTOMSCREEN_WIDTH, CGRectGetMaxY(self.defaultButton.frame));
    self.alpha              = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.94;
    }];
    
}

#pragma mark - 取消按钮点击
- (void)cancelButtonClicked:(UIButton *)sender {
    
    if (_cancelBtnBlock) {
        _cancelBtnBlock(sender);
    }
    
    [self remove];
}

#pragma mark - 自定义按钮点击
- (void)defaultBtnClicked:(UIButton *)sender {
    
    if (_defaultBtnBlock) {
        _defaultBtnBlock(sender);
    }
    [self remove];
}

#pragma mark - 移除
- (void)remove {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

#pragma mark - 展示
- (void)show {
    
    [self alertViewWithTitle:self.title
                        text:self.text];
    
    [kWindow addSubview:self];
}

@end
