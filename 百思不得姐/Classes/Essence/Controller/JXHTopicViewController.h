//
//  JXHTopicViewController.h
//  百思不得姐
//
//  Created by juxiaohui on 16/8/31.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JXHTopicType) {
    /** 全部 */
    JXHTopicTypeAll = 1,
    
    /** 图片 */
    JXHTopicTypePicture = 10,
    
    /** 段子(文字) */
    JXHTopicTypeWord = 29,
    
    /** 声音 */
    JXHTopicTypeVoice = 31,
    
    /** 视频 */
    JXHTopicTypeVideo = 41
};


@interface JXHTopicViewController : UITableViewController

@property(nonatomic, assign)JXHTopicType  type;

@end
