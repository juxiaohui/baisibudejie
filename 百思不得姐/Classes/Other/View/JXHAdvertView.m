//
//  JXHAdvertView.m
//  百思不得姐
//
//  Created by juxiaohui on 16/9/9.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "JXHAdvertView.h"

@interface JXHAdvertView ()

@property (nonatomic, weak) UIImageView *adImageView;

@property (nonatomic, weak) UIButton *countButton;

@property (nonatomic, strong) NSTimer *countTimer;

@property (nonatomic, assign) NSInteger count;

@end

@implementation JXHAdvertView

- (NSTimer *)countTimer
{
    if (!_countTimer) {
        _countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
    return _countTimer;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setup];
    }
    return self;
}

-(void)setup{

    // 1.广告图片
    UIImageView * adImageView = [[UIImageView alloc] init];
    adImageView.userInteractionEnabled = YES;
    adImageView.contentMode = UIViewContentModeScaleAspectFill;
    adImageView.clipsToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToAdVC)];
    [adImageView addGestureRecognizer:tap];
    [self addSubview:adImageView];
    _adImageView = adImageView;
    
    _adImageView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    
    // 2.跳过按钮
    UIButton * countButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [countButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    countButton.titleLabel.font = [UIFont systemFontOfSize:15];
     [countButton setTitle:[NSString stringWithFormat:@"跳过%ld", self.ADShowTime] forState:UIControlStateNormal];
    [countButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    countButton.backgroundColor = [UIColor colorWithRed:38 /255.0 green:38 /255.0 blue:38 /255.0 alpha:0.6];
    countButton.layer.cornerRadius = 4;
    [self addSubview:countButton];
    _countButton = countButton;
    _countButton.sd_layout
    .widthIs(60)
    .heightIs(30)
    .topSpaceToView(self,30)
    .rightSpaceToView(self,24);
}

-(void)setImgFilePath:(NSString *)imgFilePath{

    _imgFilePath = imgFilePath;
    self.adImageView.image = [UIImage imageWithContentsOfFile:_imgFilePath];
}

- (void)countDown
{
    _count --;
    [_countButton setTitle:[NSString stringWithFormat:@"跳过%ld",(long)_count] forState:UIControlStateNormal];
    if (_count == 0) {
        
        [self dismiss];
    }
}

- (void)showWithTime:(NSInteger )ADShowTime{
    
    self.ADShowTime = ADShowTime;
    
    [self show];
}

-(void)show{

    // 倒计时方法1：GCD
    [self startCoundown];
    
    // 倒计时方法2：定时器
    //[self startTimer];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

-(void)startTimer{
    
    _count = _ADShowTime;
    [[NSRunLoop mainRunLoop] addTimer:self.countTimer forMode:NSRunLoopCommonModes];
}

-(void)startCoundown{

    __block NSInteger timeout = self.ADShowTime + 1;
    
    //创建一个定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    // 设置定时器的各种属性（几时开始任务，每隔多长时间执行一次）
    // GCD的时间参数，一般是纳秒（1秒 == 10的9次方纳秒）
    // 何时开始执行第一个任务
    // dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC)

    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC));
    
    uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
    
    dispatch_source_set_timer(timer, start, interval, 0);

    dispatch_source_set_event_handler(timer, ^{
        
        if (timeout<=1) { //倒计时结束，关闭
            dispatch_cancel(timer);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismiss];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                 [_countButton setTitle:[NSString stringWithFormat:@"跳过%zd",timeout] forState:UIControlStateNormal];
            });
            timeout--;
        }
    });

    //开启定时器
    dispatch_resume(timer);

}

- (void)pushToAdVC{
    //点击广告图时，广告图消失，同时像首页发送通知，并把广告页对应的地址传给首页
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    dic [adImageLink] = @"http://www.jianshu.com";
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AdImageDidClickNotification object:nil userInfo:dic];
    
    [self dismiss];
}


// 移除广告页面
- (void)dismiss
{
    [self.countTimer invalidate];
    self.countTimer = nil;
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.alpha = 0.f;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}

@end
