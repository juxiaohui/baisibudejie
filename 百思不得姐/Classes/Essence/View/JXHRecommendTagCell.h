//
//  JXHRecommendTagCell.h
//  百思不得姐
//
//  Created by juxiaohui on 16/8/31.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JXHRecommendTagModel;

typedef void(^JXHTagClickBlock)(NSString * theme_id);

@interface JXHRecommendTagCell : UITableViewCell

@property(nonatomic, strong)JXHRecommendTagModel * tagModel;

@property(nonatomic, copy)JXHTagClickBlock  block;

@end
