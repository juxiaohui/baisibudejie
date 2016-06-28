//
//  JXHMeViewController.m
//  百思不得姐
//
//  Created by juxiaohui on 16/6/28.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "JXHMeViewController.h"

@interface JXHMeViewController ()

@end

@implementation JXHMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=JXHCommonBgColor;

    self.navigationItem.title = @"我的";
    // 导航栏右边的内容
    UIBarButtonItem *moonItem = [UIBarButtonItem itemWithImage:@"mine-moon-icon" highImage:@"mine-moon-icon-click" target:self action:@selector(moonClick)];
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"mine-setting-icon" highImage:@"mine-setting-icon-click" target:self action:@selector(settingClick)];
    self.navigationItem.rightBarButtonItems = @[settingItem, moonItem];
}

-(void)moonClick{

}

-(void)settingClick{
    
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
