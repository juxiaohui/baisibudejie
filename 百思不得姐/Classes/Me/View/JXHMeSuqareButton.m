//
//  JXHMeSuqareButton.m
//  百思不得姐
//
//  Created by juxiaohui on 16/8/23.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "JXHMeSuqareButton.h"

@implementation JXHMeSuqareButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        self.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    self.imageView.jxh_y = self.jxh_height * 0.2;
    
    self.imageView.jxh_height = self.jxh_height * 0.5;
    
    self.imageView.jxh_width =self.imageView.jxh_height;
    
    self.imageView.jxh_centerX = self.jxh_width  * 0.5;
    
    self.titleLabel.jxh_x = 0 ;
    
    self.titleLabel.jxh_y = self.imageView.jxh_bottom;
    
    self.titleLabel.jxh_width = self.jxh_width;
    
    self.titleLabel.jxh_height = self.jxh_height - self.titleLabel.jxh_y;
}

@end
