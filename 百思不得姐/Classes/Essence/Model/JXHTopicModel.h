//
//  JXHTopicModel.h
//  百思不得姐
//
//  Created by juxiaohui on 16/9/1.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JXHThemesModel;

@interface JXHTopicModel : NSObject


@property (nonatomic, copy) NSString *created_at;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *is_gif;

@property (nonatomic, copy) NSString *image2;

@property (nonatomic, copy) NSString *voicetime;

@property (nonatomic, copy) NSString *voicelength;

@property (nonatomic, copy) NSString *forward;

@property (nonatomic, copy) NSString *playfcount;

@property (nonatomic, copy) NSString *repost;

@property (nonatomic, copy) NSString *image1;

@property (nonatomic, strong) NSArray *top_cmt;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) NSInteger theme_type;

@property (nonatomic, copy) NSString *hate;

@property (nonatomic, copy) NSString *image0;

@property (nonatomic, copy) NSString *comment;

@property (nonatomic, copy) NSString *passtime;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *tag;

@property (nonatomic, copy) NSString *playcount;

@property (nonatomic, copy) NSString *cdn_img;

@property (nonatomic, copy) NSString *theme_name;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, copy) NSString *favourite;

@property (nonatomic, copy) NSString *from;

@property (nonatomic, strong) NSArray<JXHThemesModel *> *themes;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *height;

@property (nonatomic, copy) NSString *jie_v;

@property (nonatomic, copy) NSString *videotime;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *bookmark;

@property (nonatomic, copy) NSString *cai;

@property (nonatomic, copy) NSString *screen_name;

@property (nonatomic, copy) NSString *profile_image;

@property (nonatomic, copy) NSString *love;

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *mid;

@property (nonatomic, assign) NSInteger theme_id;

@property (nonatomic, copy) NSString *original_pid;

@property (nonatomic, copy) NSString *sina_v;

@property (nonatomic, copy) NSString *image_small;

@property (nonatomic, copy) NSString *weixin_url;

@property (nonatomic, copy) NSString *voiceuri;

@property (nonatomic, copy) NSString *videouri;

@property (nonatomic, copy) NSString *width;

@end

@interface JXHThemesModel : NSObject

@property (nonatomic, copy) NSString *theme_id;

@property (nonatomic, copy) NSString *theme_type;

@property (nonatomic, copy) NSString *theme_name;

@end

