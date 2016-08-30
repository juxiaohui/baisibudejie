//
//  NSString+JXHFileSize.m
//  百思不得姐
//
//  Created by juxiaohui on 16/8/24.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "NSString+JXHFileSize.h"

@implementation NSString (JXHFileSize)

//-(unsigned long long)fileSize{
//
//    unsigned long long totalSize = 0 ;
//    
//    //文件管理者
//    NSFileManager * manager = [NSFileManager defaultManager];
//    
//    NSDictionary * attrs = [manager attributesOfItemAtPath:self error:nil];
//    
//    if ( [attrs.fileType isEqualToString:NSFileTypeDirectory]) {//文件夹
//        
//        //获取文件夹的大小 == 获取文件夹内所有文件的大小
//        
//        NSDirectoryEnumerator *fileEnumerator = [manager enumeratorAtPath:self];
//        
//        for (NSString * subpath in fileEnumerator) {
//            
//            //全路径
//            NSString * fullPath = [self stringByAppendingPathComponent:subpath];
//            
//            //全路径下的文件属性
//            NSDictionary * attrs = [manager attributesOfItemAtPath:fullPath error:nil];
//            
//            totalSize += attrs.fileSize;
//        }
//
//    }else{
//    
//        totalSize = attrs.fileSize;
//    }
//    
//    return totalSize;
//}


-(unsigned long long)fileSize{
    
    unsigned long long totalSize = 0 ;
    
    //文件管理者
    NSFileManager * manager = [NSFileManager defaultManager];
    
    //是否是文件夹
    BOOL isDirectory = NO;
    
    //路径是否存在
    BOOL exists =[manager fileExistsAtPath:self isDirectory:&isDirectory];
    
    if (!exists) return 0;
    
    NSDictionary * attrs = [manager attributesOfItemAtPath:self error:nil];
    
    if (isDirectory) {//文件夹
        
        //获取文件夹的大小 == 获取文件夹内所有文件的大小
        
        NSDirectoryEnumerator *fileEnumerator = [manager enumeratorAtPath:self];
        
        for (NSString * subpath in fileEnumerator) {
            
            //全路径
            NSString * fullPath = [self stringByAppendingPathComponent:subpath];
            
            //全路径下的文件属性
            NSDictionary * attrs = [manager attributesOfItemAtPath:fullPath error:nil];
            
            totalSize += attrs.fileSize;
        }
        
    }else{
        
        totalSize = attrs.fileSize;
    }

    return totalSize;
}


@end
