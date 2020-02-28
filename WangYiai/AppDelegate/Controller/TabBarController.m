//
//  TabBarController.m
//  Luzhou reading non - network technology co. LTD.
//
//  Created by jejms on 2018/2/26.
//  Copyright © 2018年 泸州阅非网络科技有限公司. All rights reserved.
//
/******************    TabBar          *************/
#define MallClassKey   @"rootVCClassString"
#define MallTitleKey   @"title"
#define MallImgKey     @"imageName"
#define MallSelImgKey  @"selectedImageName"
#import <UIKit/UIKit.h>
#import "TabBarController.h"
// Controllers
#import "NavigationController.h"
// Models
#import "TabBar.h"
// Views
@interface TabBarController ()<UITabBarControllerDelegate>
@property(nonatomic,strong) NSMutableArray *seleIndexArr;//前一个控制器标识
@end

@implementation TabBarController
//seleIndexArr懒加载
-(NSMutableArray *)seleIndexArr{
    if (!_seleIndexArr) {
        _seleIndexArr = [NSMutableArray array];
    }
    return _seleIndexArr;
}
//生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    [self setUpTabBar];
    [self addDcChildViewContorller];
    self.selectedIndex = 0;
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [UITabBar appearance].translucent = NO;
}

#pragma mark - 更换系统tabbar
-(void)setUpTabBar
{
    TabBar *tabBar = [[TabBar alloc] init];
    tabBar.backgroundColor = [UIColor whiteColor];
//    tabBar.backgroundColor = RGBA(25, 25, 25, 1);
    //KVC把系统换成自定义
    [self setValue:tabBar forKey:@"tabBar"];
}
#pragma mark - 添加子控制器
- (void)addDcChildViewContorller
{
    NSArray *childArray = @[
                            @{MallClassKey  : @"ShenzhenViewController",
                              MallTitleKey  : @"深圳",
                              MallImgKey    : @"深圳_shenzhen",
                              MallSelImgKey : @"深圳_shenzhen"},
                            
                            @{MallClassKey  : @"ShanghaiViewController",
                              MallTitleKey  : @"上海",
                              MallImgKey    : @"上海浦东发展银行",
                              MallSelImgKey : @"上海浦东发展银行"}
                            
//                            @{MallClassKey  : @"MyViewController",
//                              MallTitleKey  : @"我的",
//                              MallImgKey    : @"我的",
//                              MallSelImgKey : @"我的"}
                            
//                            @{MallClassKey  : @"MyViewController",
//                              MallTitleKey  : @"我的",
//                              MallImgKey    : @"我的",
//                              MallSelImgKey : @"我的1"}
                            
//                            @{MallClassKey  : @"MyViewController",
//                              MallTitleKey  : @"我的",
//                              MallImgKey    : @"tabr_05_down",
//                              MallSelImgKey : @"tabr_05_up"},
                            
                            ];
    [childArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIViewController *vc = [NSClassFromString(dict[MallClassKey]) new];
//        vc.navigationItem.title = dict[MallTitleKey];
        //        vc.navigationItem.title = ([dict[MallTitleKey] isEqualToString:@"首页"] || [dict[MallTitleKey] isEqualToString:@"分类"]) ? nil : dict[MallTitleKey];
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:vc];
        UITabBarItem *item = nav.tabBarItem;
        item.title = dict[MallTitleKey];
        item.image = [UIImage imageNamed:dict[MallImgKey]];
        item.selectedImage = [[UIImage imageNamed:dict[MallSelImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.imageInsets = UIEdgeInsetsMake(0, 0,-4, 0);//（当只有图片的时候）需要自动调整
        NSMutableDictionary *att = [NSMutableDictionary dictionary];
        att[NSForegroundColorAttributeName] = maiColor;
        [item setTitleTextAttributes:att forState:UIControlStateSelected];
        [self addChildViewController:nav];
       
    }];

}
#pragma mark - <UITabBarControllerDelegate>
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    //添加seleIndexArr标识
    [self.seleIndexArr addObject:[NSString stringWithFormat:@"%lu",self.selectedIndex]];
    //点击tabBarItem动画
    [self tabBarButtonClick:[self getTabBarButton]];
//    if (self.selectedIndex == 0) {
//        //创建通知
//        //通过通知中心发送通知
////        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"jumpNotifi" object:nil userInfo:nil]];
//
//        //跳转通知
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PopNotifiClick) name:@"PopNotifi"object:nil];
//    }
    
}
////Pop通知事件
//-(void)PopNotifiClick{
//    //Tabbar 跳转
//
//    if (self.seleIndexArr.count == 1 || [self.seleIndexArr[self.seleIndexArr.count - 2] integerValue] == 0 ){
//                self.selectedIndex = 1;
//            }
//    else{
//        NSString *str = [self.seleIndexArr objectAtIndex:self.seleIndexArr.count - 2];
//        self.selectedIndex = [str integerValue];
//    }
//
//}
- (UIControl *)getTabBarButton{
    NSMutableArray *tabBarButtons = [[NSMutableArray alloc]initWithCapacity:0];
    
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]){
            [tabBarButtons addObject:tabBarButton];
        }
    }
    UIControl *tabBarButton = [tabBarButtons objectAtIndex:self.selectedIndex];
    
    return tabBarButton;
}
#pragma mark - 点击动画
- (void)tabBarButtonClick:(UIControl *)tabBarButton
{
//    for (UIView *imageView in tabBarButton.subviews) {
//        if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
//            //需要实现的帧动画,这里根据自己需求改动
//            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
//            animation.keyPath = @"transform.scale";
//            animation.values = @[@1.0,@1.1,@0.9,@1.0];
//            animation.duration = 0.3;
//            animation.calculationMode = kCAAnimationCubic;
//            //添加动画
//            [imageView.layer addAnimation:animation forKey:nil];
//        }
//    }
}
#pragma mark - 禁止屏幕旋转


- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)
}
-(void)dealloc{
//     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PopNotifi" object:self];//销毁跳转通知
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
