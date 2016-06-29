//
//  LJFPhotoPickerController.m
//  图片选择器
//
//  Created by Lone on 16/6/24.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "LJFPhotoPickerController.h"


@interface LJFPhotoPickerController ()

@end

@implementation LJFPhotoPickerController

@dynamic delegate;

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


- (instancetype)initWithBlock:(void (^)(NSArray<LJFAssetModel *> *))finishBlock
{
    LJFAlbumsListController *VC = [LJFAlbumsListController new];
    if (self = [super initWithRootViewController:VC]) {
        self.finishBlock = finishBlock;
        self.isSupportMultipleSelect = YES;
    }
    return self;
}

- (instancetype)initWithBlocSingleSelect:(void (^)(UIImage *))finishBlock
{
    LJFAlbumsListController *VC = [LJFAlbumsListController new];
    if (self = [super initWithRootViewController:VC]) {
        self.singleFinishBlock = finishBlock;
        self.isSupportMultipleSelect = NO;
    }
    return self;
}

#pragma mark - 重写push方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
 
    if (self.childViewControllers.count > 0) {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(3, 0, 50, 44);
        [backButton setImage:[UIImage imageNamed:@"navi_back"]
                    forState:UIControlStateNormal];
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        backButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [backButton addTarget:self action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark - 设置导航栏颜色
- (void)setNavGationBarColor:(UIColor *)navGationBarColor
{
    _navGationBarColor = navGationBarColor;
    self.navigationBar.barTintColor = navGationBarColor;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    statusBarView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:statusBarView];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = YES;
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.barTintColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
