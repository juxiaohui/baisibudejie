//
//  JXHMeFootView.m
//  百思不得姐
//
//  Created by juxiaohui on 16/8/22.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "JXHMeFootView.h"
#import "JXHMeSquareModel.h"
#import <UIButton+WebCache.h>
#import "JXHMeSuqareButton.h"
#import "JXHWebViewController.h"
#import "JXHWKWebViewController.h"
#import <SafariServices/SafariServices.h>//Safari控制器

@implementation JXHMeFootView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    
   // self.backgroundColor = [UIColor whiteColor];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    params[@"a"] = @"square";
    params[@"c"] = @"topic";
    
    [JXHNetWorkRequest requestWithUrl:@"http://api.budejie.com/api/api_open.php" params:params useCache:NO httpMedthod:JXHGETRequest progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        
    } successBlock:^(id response) {

        NSArray * squareList = [JXHMeSquareModel mj_objectArrayWithKeyValuesArray:response[@"square_list"]];
        [self setupSquares:squareList];
        
    } failBlock:^(NSError *error) {
        
    }];
}

-(void)setupSquares:(NSArray *)squares{
    
    NSUInteger count = squares.count;
    
    int maxColsCount = 4 ;
    
    CGFloat buttonW = self.jxh_width / maxColsCount;
    
    CGFloat buttonH = buttonW;
    
    for (NSUInteger i =0; i<count; i++) {
        
        JXHMeSquareModel * square = [squares objectAtIndex:i];
        
        JXHMeSuqareButton * button = [JXHMeSuqareButton buttonWithType:UIButtonTypeCustom];
        
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundColor:[UIColor whiteColor]];
        
        [self addSubview:button];
        button.jxh_x = (i % maxColsCount) * buttonW ;
        button.jxh_y = (i / maxColsCount) * buttonH;
        button.jxh_width  = buttonW;
        button.jxh_height = buttonH;
        
        button.square = square;
        [button setTitle:square.name forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"mainCellBackground"] forState:UIControlStateNormal];
        [button sd_setImageWithURL:[NSURL URLWithString:square.icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"post_placeholderImage"]];
    }
    
   // NSUInteger  rowsCount = (总数 + 每一行显示的数量 -1 ) / 每一行显示的数量 ;
    
    self.jxh_height = self.subviews.lastObject.jxh_bottom;
    
    //重新设置footView,/*********刷新数据重新计算contentsize*********/
    UITableView * tableView =(UITableView *) self.superview;
    
//    tableView.contentSize = CGSizeMake(0, self.jxh_bottom);
    
    tableView.tableFooterView = self;
    
    [tableView reloadData];
}

-(void)buttonClick:(JXHMeSuqareButton *)button {

    if ([button.square.url hasPrefix:@"http"] == NO) {
        
        JXHLog(@"%@",button.square.url);
        return;
    }
//    
//    SFSafariViewController * web = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:button.square.url]];
    
    
//    JXHWebViewController * web = [[JXHWebViewController alloc]init];
//    web.url = button.square.url;
//    
    
    JXHWKWebViewController * web = [[JXHWKWebViewController alloc]init];
    web.url = button.square.url;
    
    web.navigationItem.title = [button currentTitle];
    
    // 取出当前选中的导航控制器
    UITabBarController *rootVc = (UITabBarController *)self.window.rootViewController;
    
    UINavigationController *nav = (UINavigationController *)rootVc.selectedViewController;
    //[nav presentViewController:web animated:YES completion:nil];
    
    [nav pushViewController:web animated:YES];

    
}
@end
