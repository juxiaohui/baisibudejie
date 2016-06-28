//
//  UIBarButtonItem+JXHExt.m
//  百思不得姐
//
//  Created by juxiaohui on 16/6/28.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "UIBarButtonItem+JXHExt.h"

@implementation UIBarButtonItem (JXHExt)

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action{

    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[self alloc]initWithCustomView:button];

}

@end
