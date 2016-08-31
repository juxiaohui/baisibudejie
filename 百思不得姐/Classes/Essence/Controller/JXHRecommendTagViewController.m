//
//  JXHRecommendTagViewController.m
//  百思不得姐
//
//  Created by juxiaohui on 16/8/31.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "JXHRecommendTagViewController.h"
#import "JXHRecommendTagCell.h"
#import "JXHRecommendTagModel.h"

@interface JXHRecommendTagViewController ()

@property(nonatomic, strong)NSMutableArray * tagList;

@end

@implementation JXHRecommendTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    
    [self getTags];
}

-(void)setupTableView{
    
    self.tableView.backgroundColor = JXHCommonBgColor;
    self.navigationItem.title = @"推荐标签";
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.rowHeight = 70;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JXHRecommendTagCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([JXHRecommendTagCell class])];
    
}

-(void)getTags{
    
    [SVProgressHUD show];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"a"] = @"tag_recommend";
    params[@"action"] = @"sub";
    params[@"c"] = @"topic";

    [JXHNetWorkRequest requestWithUrl:@"http://api.budejie.com/api/api_open.php" params:params useCache:NO httpMedthod:JXHGETRequest progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {
        
        self.tagList = [JXHRecommendTagModel mj_objectArrayWithKeyValuesArray:response];
        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
        
    } failBlock:^(NSError *error) {
        
        [SVProgressHUD dismiss];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.tagList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JXHRecommendTagCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JXHRecommendTagCell class]) forIndexPath:indexPath];
    
    cell.tagModel = [self.tagList objectAtIndex:indexPath.row];
    
    [cell setBlock:^void(NSString * theme_id){
    
        JXHLog(@"%@",theme_id);
    }];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
