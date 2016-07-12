//
//  JXHLoginRegisterController.m
//  百思不得姐
//
//  Created by juxiaohui on 16/7/12.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "JXHLoginRegisterController.h"
#import "JXHQuickLoginButton.h"

@interface JXHLoginRegisterController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end

@implementation JXHLoginRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view insertSubview:self.backgroundImageView atIndex:0];
    
}


-(UIStatusBarStyle)preferredStatusBarStyle{

    return UIStatusBarStyleLightContent;
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
