//
//  JXHQuickLoginButton.m
//  百思不得姐
//
//  Created by juxiaohui on 16/7/12.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "JXHQuickLoginButton.h"

@implementation JXHQuickLoginButton


-(void)awakeFromNib{

    self.titleLabel.textAlignment = NSTextAlignmentCenter;

}

-(void)layoutSubviews{

    [super layoutSubviews];
    
    self.imageView.jxh_y=0;
    
    self.imageView.jxh_centerX=self.jxh_width * 0.5;
    
    self.titleLabel.jxh_x=0;
    
    self.titleLabel.jxh_y=self.imageView.jxh_height;
    
    self.titleLabel.jxh_width=self.jxh_width;
    
    self.titleLabel.jxh_height=self.jxh_height-self.titleLabel.jxh_y;
}

@end
