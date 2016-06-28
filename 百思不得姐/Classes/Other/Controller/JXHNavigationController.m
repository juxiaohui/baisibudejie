//
//  JXHNavigationController.m
//  百思不得姐
//
//  Created by juxiaohui on 16/6/28.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "JXHNavigationController.h"

@interface JXHNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation JXHNavigationController

+(void)initialize{

    // 设置Bar 的背景和标题属性
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    
    NSMutableDictionary *barAttrs = [NSMutableDictionary dictionary];
    
    barAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];
    
    [[UINavigationBar appearance] setTitleTextAttributes:barAttrs];
    
    
    //设置Item的标题属性
    
  //  [UIBarButtonItem appearance]

}

- (void)viewDidLoad {
    [super viewDidLoad];

     self.interactivePopGestureRecognizer.delegate = self;
}



-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.childViewControllers.count >= 1) {
        // 左上角的返回
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [backButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        [backButton sizeToFit];
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        viewController.hidesBottomBarWhenPushed = YES; // 隐藏底部的工具条
    }
    
    [super pushViewController:viewController animated:animated];
}


- (void)back
{
    [self popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UIGestureRecognizerDelegate>
/**
 * 每当用户触发[返回手势]时都会调用一次这个方法
 * 返回值:返回YES,手势有效; 返回NO,手势失效
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    return self.childViewControllers.count > 1;
}


@end
