//
//  JXHTabBarController.m
//  百思不得姐
//
//  Created by JesnLu on 16/6/13.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//


#import "JXHTabBarController.h"
#import "JXHCustomTabBar.h"
#import "JXHEssenceViewController.h"
#import "JXHFollowViewController.h"
#import "JXHNewViewController.h"
#import "JXHMeViewController.h"
#import "JXHNavigationController.h"

@interface JXHTabBarController ()

@end

@implementation JXHTabBarController

+(void)initialize{

    NSMutableDictionary * normalDic = [NSMutableDictionary dictionary];
    
    normalDic[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    normalDic[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    
    NSMutableDictionary * selectlDic = [NSMutableDictionary dictionary];
    
    selectlDic[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    [[UITabBarItem appearance] setTitleTextAttributes:normalDic forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:selectlDic forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self addChildController];    
    
}

-(void)addChildController{
    
    [self setupChildVc:[[JXHEssenceViewController alloc] init] title:@"精华" image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon"];
    
    [self setupChildVc:[[JXHNewViewController alloc] init] title:@"新帖" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];
    
     [self setupChildVc:[[JXHFollowViewController alloc] init] title:@"关注" image:@"tabBar_new_icon" selectedImage:@"tabBar_new_click_icon"];
    
    [self setupChildVc:[[JXHMeViewController alloc] init] title:@"我" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];

    [self setValue:[[JXHCustomTabBar alloc]init] forKey:@"tabBar"];

}
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 包装一个导航控制器
    JXHNavigationController *nav = [[JXHNavigationController alloc] initWithRootViewController:vc];
    
    [self addChildViewController:nav];
    
    // 设置子控制器的tabBarItem
    nav.tabBarItem.title = title;
    
    nav.tabBarItem.image = [UIImage imageNamed:image];
    
    nav.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
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
