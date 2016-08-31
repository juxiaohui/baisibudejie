//
//  JXHRecommendTagModel.h
//  百思不得姐
//
//  Created by juxiaohui on 16/8/31.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXHRecommendTagModel : NSObject

@property (nonatomic, copy) NSString *image_list;

@property (nonatomic, copy) NSString *theme_id;

@property (nonatomic, copy) NSString *theme_name;

@property (nonatomic, assign) NSInteger is_sub;

@property (nonatomic, assign) NSInteger is_default;

@property (nonatomic, copy) NSString *sub_number;

@end
