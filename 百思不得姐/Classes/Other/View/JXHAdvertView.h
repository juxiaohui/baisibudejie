//
//  JXHAdvertView.h
//  百思不得姐
//
//  Created by juxiaohui on 16/9/9.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXHAdvertView : UIView

/** 图片路径*/
@property (nonatomic, copy) NSString *imgFilePath;

/** 广告图的显示时间*/
@property (nonatomic, assign) NSInteger ADShowTime;

/** 图片对应的url地址*/
@property (nonatomic, copy) NSString *imgLinkUrl;

/** 显示广告页面方法*/
- (void)showWithTime:(NSInteger )ADShowTime;

-(void)show;

@end
