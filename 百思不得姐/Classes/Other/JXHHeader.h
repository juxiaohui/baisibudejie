//
//  JXHHeader.h
//  百思不得姐
//
//  Created by JesnLu on 16/6/13.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#ifndef JXHHeader_h
#define JXHHeader_h

#define SH  [UIScreen mainScreen].bounds.size.height

#define SW  [UIScreen mainScreen].bounds.size.width

#define ScreenWidth  (SH < SW ? SH : SW)

#define ScreenHeight (SH > SW ? SH : SW)

#define JXHRGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define JXHRGBAColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define JXHCommonBgColor JXHRGBColor(215,215,215);

#define JXHLogFunc JXHLog(@"%s", __func__);

#define JXHWeakSelf __weak typeof(self) weakSelf = self;

#endif /* JXHHeader_h */
