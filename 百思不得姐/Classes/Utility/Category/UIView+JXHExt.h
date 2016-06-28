//
//  UIView+JXHExt.h
//  百思不得姐
//
//  Created by JesnLu on 16/6/14.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JXHExt)

@property (nonatomic, assign) CGFloat jxh_x;

@property (nonatomic, assign) CGFloat jxh_y;

@property (nonatomic, assign) CGFloat jxh_width;

@property (nonatomic, assign) CGFloat jxh_height;

@property (nonatomic, assign) CGFloat jxh_centerX;

@property (nonatomic, assign) CGFloat jxh_centerY;
/**
 *  最大X
 */
@property (nonatomic, assign) CGFloat jxh_right;
/**
 *  最大Y
 */
@property (nonatomic, assign) CGFloat jxh_bottom;
@end
