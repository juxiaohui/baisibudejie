//
//  NSCalendar+JXHExt.m
//  百思不得姐
//
//  Created by juxiaohui on 16/9/8.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "NSCalendar+JXHExt.h"

@implementation NSCalendar (JXHExt)

+(instancetype)calender{
    
    if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
        return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }else{
        return [NSCalendar currentCalendar];
    }
}

@end
