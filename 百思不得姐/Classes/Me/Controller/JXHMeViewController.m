//
//  JXHMeViewController.m
//  百思不得姐
//
//  Created by juxiaohui on 16/6/28.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "JXHMeViewController.h"
#import "JXHMeCell.h"
#import "JXHMeFootView.h"
#import "JXHSettingViewController.h"

@interface JXHMeViewController ()

@end

@implementation JXHMeViewController

//  重写init
-(instancetype)init{
    
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupTableView];

}

-(void)setupNav{

    self.navigationItem.title = @"我的";
    // 导航栏右边的内容
    UIBarButtonItem *moonItem = [UIBarButtonItem itemWithImage:@"mine-moon-icon" highImage:@"mine-moon-icon-click" target:self action:@selector(moonClick)];
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"mine-setting-icon" highImage:@"mine-setting-icon-click" target:self action:@selector(settingClick)];
    self.navigationItem.rightBarButtonItems = @[settingItem, moonItem];
}

-(void)moonClick{

}

-(void)settingClick{
    
    JXHSettingViewController * setting = [[JXHSettingViewController alloc]init];
    [self.navigationController pushViewController:setting animated:YES];
}

-(void)setupTableView{

    self.tableView.backgroundColor=JXHCommonBgColor;
    self.tableView.contentInset = UIEdgeInsetsMake(JXHMargin-35, 0, 0, 0);
    self.tableView.sectionFooterHeight =JXHMargin;
    self.tableView.sectionHeaderHeight =0;
    self.tableView.tableFooterView = [[JXHMeFootView alloc]init];
}

#pragma mark - TableView协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"cell";
    
    JXHMeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    
    if (!cell) {
        cell = [[JXHMeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    
    if (indexPath.section==0) {
        cell.textLabel.text = @"登陆/注册";
        cell.imageView.image = [UIImage imageNamed:@"Navigation"];
    }else if (indexPath.section==1){
        cell.textLabel.text = @"离线下载";
        cell.imageView.image =nil;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==2)return 100;
        
    return 44;
}


//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 10;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0;
//}

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
