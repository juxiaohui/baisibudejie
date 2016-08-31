//
//  UIImage+JXHCircle.h
//  百思不得姐
//
//  Created by juxiaohui on 16/8/31.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JXHCircle)


/**
 * 返回一张圆形图片
 */
- (instancetype)circleImage;

/**
 * 返回一张圆形图片
 */
+ (instancetype)circleImageNamed:(NSString *)name;

@end
