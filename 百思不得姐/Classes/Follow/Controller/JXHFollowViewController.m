//
//  JXHFollowViewController.m
//  百思不得姐
//
//  Created by juxiaohui on 16/6/28.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "JXHFollowViewController.h"
#import "JXHLoginRegisterController.h"

@interface JXHFollowViewController ()

@end

@implementation JXHFollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=JXHCommonBgColor;
    
    self.navigationItem.title = @"我的关注";
    
    // 导航栏左边的内容
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" highImage:@"friendsRecommentIcon-click" target:self action:@selector(friendsRecommendClick)];

}

-(void)friendsRecommendClick{
    
}
- (IBAction)loginRegistButtonClick:(UIButton *)sender {
    
    JXHLoginRegisterController * loginRegistVC = [[JXHLoginRegisterController alloc]init];
    
    [self presentViewController:loginRegistVC animated:YES completion:nil];
    
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
