//
//  JXHCustomTabBar.m
//  百思不得姐
//
//  Created by JesnLu on 16/6/14.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "JXHCustomTabBar.h"

@interface JXHCustomTabBar ()

@property(nonatomic, weak)UIButton * publishButton;

@end

@implementation JXHCustomTabBar


-(instancetype)initWithFrame:(CGRect)frame{

    if (self=[super initWithFrame:frame]) {
        
        self.backgroundImage = [UIImage imageNamed:@"tabbar-light"];
        
        UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        
        [publishButton sizeToFit];
        
        [publishButton addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:publishButton];
        
        self.publishButton = publishButton;
    }
    
    return self;
}

-(void)publishClick{
    
    


}

-(void)layoutSubviews{

    [super layoutSubviews];
    
    self.publishButton.center = CGPointMake(self.jxh_width * 0.5, self.jxh_height * 0.5);
    
    CGFloat buttonW = self.jxh_width /5;
    
    CGFloat buttonH = self.jxh_height;
    
    CGFloat buttonY =0;
    
    int index=0;
    
    for (UIView * view in self.subviews) {
//        if (![NSStringFromClass(view.class) isEqualToString:@"UITabBarButton"])continue;
        
        if (view.class != NSClassFromString(@"UITabBarButton"))continue;
        
        CGFloat buttonX = index * buttonW;
        
        if (index>=2) {
            
            buttonX +=buttonW;
        }
        
        view.frame=CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        index ++;
    }
}



@end
