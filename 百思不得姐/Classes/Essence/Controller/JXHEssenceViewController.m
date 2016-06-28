//
//  JXHEssenceViewController.m
//  百思不得姐
//
//  Created by juxiaohui on 16/6/28.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "JXHEssenceViewController.h"

@interface JXHEssenceViewController ()

@end

@implementation JXHEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JXHLogFunc;
    
    self.view.backgroundColor=JXHCommonBgColor;
    
    
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
    
}


-(void)tagClick{

    [self.navigationController pushViewController:[[UIViewController alloc]init] animated:YES];
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
