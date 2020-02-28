//
//  NavigationController.m
//  Luzhou reading non - network technology co. LTD.
//
//  Created by jejms on 2018/2/26.
//  Copyright © 2018年 泸州阅非网络科技有限公司. All rights reserved.
//
//宏
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define PFR [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? @"PingFangSC-Regular" : @"PingFang SC"
#define PFR20Font [UIFont fontWithName:PFR size:20];
#import "NavigationController.h"
// Controllers
//#import "PunchCardViewController.h"
// Models

// Views

// Vendors
//#import <UINavigationController+FDFullscreenPopGesture.h>
// Categories
//#import "UIBarButtonItem+BarButtonItem.h"
// Others
@interface NavigationController ()

@end

@implementation NavigationController
#pragma mark - load初始化一次
+ (void)load
{
 [self setUpBase];
}
#pragma mark - LifeCyle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//  self.fd_fullscreenPopGestureRecognizer.enabled = NO;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
//#pragma mark - <初始化>
+ (void)setUpBase
{
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.barTintColor = maiColor;
    [bar setShadowImage:[UIImage new]];
    [bar setTintColor:[UIColor whiteColor]];

    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    // 设置导航栏字体颜色
//    UIColor * naiColor = [UIColor whiteColor];
    attributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:Ratio(20)];
    bar.titleTextAttributes = attributes;
    
//    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleDefault;
}
#pragma mark - <返回>
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
//////
    if (self.childViewControllers.count >= 1) {
//        //返回按钮自定义
//        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStyleDone target:self action:nil];
////
////        //影藏BottomBar
        viewController.hidesBottomBarWhenPushed = YES;
    }
//////    //跳转 prepareForSegue
    [super pushViewController:viewController animated:animated];
}

#pragma mark - 点击
- (void)backClick {
//    if (self.tabBarController.selectedIndex == 0 && self.childViewControllers.count == 2) {
////        发送PopNotifi通知
//        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"PopNotifi" object:nil userInfo:nil]];
//    }else{
//
//    }

    [self popViewControllerAnimated:YES];
}
-(void)setSeleIndex:(NSString *)seleIndex{
    _seleIndex = seleIndex;
}


-(void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"popNotifi" object:self];//销毁跳转通知
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
