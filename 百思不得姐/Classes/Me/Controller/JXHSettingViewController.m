//
//  JXHSettingViewController.m
//  百思不得姐
//
//  Created by juxiaohui on 16/8/23.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "JXHSettingViewController.h"

#import <SDImageCache.h>

#import "NSString+JXHFileSize.h"

@interface JXHSettingViewController ()

@end

@implementation JXHSettingViewController


//  重写init
-(instancetype)init{
    
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(JXHMargin-35, 0, 0, 0);
    
    NSLog(@"%zd",[@"/Users/luzifei/Desktop/微令内部通讯录.xlsx" fileSize]);
    self.tableView.backgroundColor= JXHCommonBgColor;
    
    self.navigationItem.title = @"设置";
    
    JXHLog(@"%@",NSHomeDirectory());
    
    [self getCacheSize];
}

-(void)getCacheSize{
    
    
    //获取SDWebImage缓存图片的大小
    NSInteger size = [[SDImageCache sharedImageCache] getSize];
    
    //caches 路径
    NSString * cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    
    NSString * filePath = [cachesPath stringByAppendingPathComponent:@"MP3"];
    
    unsigned long long totalSize = 0 ;
    
    //文件管理者
    NSFileManager * manager = [NSFileManager defaultManager];
    
    //获取文件夹的大小 == 获取文件夹内所有文件的大小
    
    NSDirectoryEnumerator *fileEnumerator = [manager enumeratorAtPath:filePath];
    
//                =
//                =
//                =
    [manager subpathsAtPath:filePath];
    
    for (NSString * subpath in fileEnumerator) {
        
        //全路径
        NSString * fullPath = [filePath stringByAppendingPathComponent:subpath];
        
        //全路径下的文件属性
        NSDictionary * attrs = [manager attributesOfItemAtPath:fullPath error:nil];
       // totalSize += [attrs[NSFileSize] unsignedIntegerValue];
        
        totalSize += attrs.fileSize;
    }
    
    NSLog(@"%zd",totalSize);
    //获取路径的属性
    //NSDictionary * dic = [manager attributesOfItemAtPath:filePath error:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 15;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];

    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    
    cell.textLabel.text =@"清除缓存";
    
    cell.detailTextLabel.text = @"正在计算缓存大小";
    
    UIActivityIndicatorView * indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [indicatorView startAnimating];
    
    cell.accessoryView =indicatorView;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString * cache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject ;
        NSString * cachePath = [cache stringByAppendingPathComponent:@"photos"];
        
        unsigned long long size = cachePath.fileSize;
        
        size  += [[SDImageCache sharedImageCache] getSize];
        
        NSString * sizeText = nil;
        
        if (size>=pow(10, 9)) { // size > 1GB
            sizeText = [NSString stringWithFormat:@"%.2f GB",size / pow(10, 9)];
        } else if (size >= pow(10, 6)){ //1GB > size > 1MB
            sizeText = [NSString stringWithFormat:@"%.2f MB",size / pow(10, 6)];
        } else if (size >= pow(10, 3)){ //1MB > size > 1KB
            sizeText = [NSString stringWithFormat:@"%.2f KB",size / pow(10, 3)];
        }else{ //1KB > size
            sizeText = [NSString stringWithFormat:@"%zd B",size];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",sizeText];
            
            cell.accessoryView =nil;
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        });
    });
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [SVProgressHUD showWithStatus:@"正在清除缓存"];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
           
            NSFileManager * manager = [NSFileManager defaultManager];
            
            NSString * cache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject ;
            NSString * cachePath = [cache stringByAppendingPathComponent:@"photos"];
            
            [manager removeItemAtPath:cachePath error:nil];
            
            [manager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:NULL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [SVProgressHUD dismiss];
                
                cell.detailTextLabel.text = @"0 B";
            });
        });
    }];
}


#warning JXH
/*

 当cell进入缓存池时，系统会自动暂停cell的核心动画。当cell从缓存池中取出在此显示的时候，就不会在播放核心动画，这是需要手动开启，即cell重新显示的时候会调用控制器的数据源方法，也会调用cell本身的layoutSubviews方法，可以在这两个方法中做相关的操作。
 
*/


@end
