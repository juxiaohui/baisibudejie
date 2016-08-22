//
//  JXHMeCell.m
//  百思不得姐
//
//  Created by juxiaohui on 16/8/22.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "JXHMeCell.h"

@implementation JXHMeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.textLabel.textColor = [UIColor darkGrayColor];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
    }
    return self;
}

-(void)layoutSubviews{

    [super layoutSubviews];
    
    if (self.imageView.image==nil) return;
    
    self.imageView.jxh_y = 5;
    
    self.imageView.jxh_height = self.contentView.jxh_height - 2 * 5;
    
    self.imageView.jxh_width = self.imageView.jxh_height;
    
    self.textLabel.jxh_x = self.imageView.jxh_right +  JXHMargin;
    
}

@end
