//
//  JXHEssenceViewController.m
//  百思不得姐
//
//  Created by juxiaohui on 16/6/28.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "JXHEssenceViewController.h"
#import "JXHRecommendTagViewController.h"
#import "JXHTopicViewController.h"
#import "JXHWKWebViewController.h"

@interface JXHEssenceViewController ()<UIScrollViewDelegate>

@property(nonatomic, weak)UIView * titleView;

@property(nonatomic, weak)UIScrollView * scrollView;

@property(nonatomic, strong)NSMutableArray * titleButtons;

@property (nonatomic, weak) UIButton *selectedTitleButton;

/** 标题栏底部的指示器 */
@property (nonatomic, weak) UIView *titleBottomView;

@end

@implementation JXHEssenceViewController


-(NSMutableArray *)titleButtons{

    if (!_titleButtons) {
        _titleButtons = [NSMutableArray array];
    }
    return _titleButtons;
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goADDetail:) name:AdImageDidClickNotification object:nil];
    
    [self setupNav];
    
    [self setupChildController];
    
    [self setupScollView];
    
    [self setupTitleView];
}

-(void)setupNav{
    
    self.view.backgroundColor=JXHCommonBgColor;

    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
}

-(void)setupChildController{

    JXHTopicViewController *all = [[JXHTopicViewController alloc] init];
    all.type = JXHTopicTypeAll;
    all.title = @"全部";
    [self addChildViewController:all];
    
    JXHTopicViewController *video = [[JXHTopicViewController alloc] init];
    video.type = JXHTopicTypeVideo;
    video.title = @"视频";
    [self addChildViewController:video];
    
    JXHTopicViewController *voice = [[JXHTopicViewController alloc] init];
    voice.type = JXHTopicTypeVoice;
    voice.title = @"声音";
    [self addChildViewController:voice];
    
    JXHTopicViewController *picture = [[JXHTopicViewController alloc] init];
    picture.type = JXHTopicTypePicture ;
    picture.title = @"图片";
    [self addChildViewController:picture];
    
    JXHTopicViewController *word = [[JXHTopicViewController alloc] init];
    word.title = @"段子";
    [self addChildViewController:word];
    
}

-(void)setupScollView{

    // 不要自动调整scrollView的contentInset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.backgroundColor = JXHCommonBgColor;
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(self.childViewControllers.count * self.view.jxh_width, 0);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    // 默认显示第0个控制器
    [self scrollViewDidEndScrollingAnimation:scrollView];

}

-(void)setupTitleView{
    
    UIView * titleView = [[UIView alloc]init];
    titleView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.7];
    titleView.frame = CGRectMake(0, 64, self.view.jxh_width, 35);
    [self.view addSubview:titleView];
    _titleView = titleView;
    
    // 标签栏内部的标签按钮
    NSUInteger count = self.childViewControllers.count;
    CGFloat titleButtonH = titleView.jxh_height;
    CGFloat titleButtonW = titleView.jxh_width / count;
    for (int i = 0; i < count; i++) {
        // 创建
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [titleView addSubview:titleButton];
        [self.titleButtons addObject:titleButton];
        
        // 文字
        NSString *title = [self.childViewControllers[i] title];
        [titleButton setTitle:title forState:UIControlStateNormal];
        
        // frame
        titleButton.jxh_y = 0;
        titleButton.jxh_height = titleButtonH;
        titleButton.jxh_width = titleButtonW;
        titleButton.jxh_x = i * titleButton.jxh_width;
    }
    
    // 标签栏底部的指示器控件
    UIView *titleBottomView = [[UIView alloc] init];
    titleBottomView.backgroundColor = [self.titleButtons.lastObject titleColorForState:UIControlStateSelected];
    titleBottomView.jxh_height = 1;
    titleBottomView.jxh_y = titleView.jxh_height - titleBottomView.jxh_height;
    [titleView addSubview:titleBottomView];
    self.titleBottomView = titleBottomView;
    
    // 默认点击最前面的按钮
    UIButton *firstTitleButton = self.titleButtons.firstObject;
    [firstTitleButton.titleLabel sizeToFit];
    titleBottomView.jxh_width = firstTitleButton.titleLabel.jxh_width;
    titleBottomView.jxh_centerX = firstTitleButton.jxh_centerX;
    [self titleClick:firstTitleButton];
    
}


-(void)titleClick:(UIButton *)button{

    // 控制按钮状态
    self.selectedTitleButton.selected = NO;
    button.selected = YES;
    self.selectedTitleButton = button;
    
    // 底部控件的位置和尺寸
    [UIView animateWithDuration:0.25 animations:^{
        self.titleBottomView.jxh_width = button.titleLabel.jxh_width;
        self.titleBottomView.jxh_centerX = button.jxh_centerX;
    }];
    
    // 让scrollView滚动到对应的位置
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = self.view.jxh_width * [self.titleButtons indexOfObject:button];
    [self.scrollView setContentOffset:offset animated:YES];
}

-(void)tagClick{

    [self.navigationController pushViewController:[[JXHRecommendTagViewController alloc]init] animated:YES];
}

#pragma mark - <UIScrollViewDelegate>
/**
 * 当滚动动画完毕的时候调用（通过代码setContentOffset:animated:让scrollView滚动完毕后，就会调用这个方法）
 * 如果执行完setContentOffset:animated:后，scrollView的偏移量并没有发生改变的话，就不会调用scrollViewDidEndScrollingAnimation:方法
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 取出对应的子控制器
    int index = scrollView.contentOffset.x / scrollView.jxh_width;
    UIViewController *willShowChildVc = self.childViewControllers[index];
    
    // 如果控制器的view已经被创建过，就直接返回
    if (willShowChildVc.isViewLoaded) return;
    
    // 添加子控制器的view到scrollView身上
    willShowChildVc.view.frame = scrollView.bounds;
    [scrollView addSubview:willShowChildVc.view];
}

/**
 * 当减速完毕的时候调用（人为拖拽scrollView，手松开后scrollView慢慢减速完毕到静止）
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    // 点击按钮
    int index = scrollView.contentOffset.x / scrollView.jxh_width;
    [self titleClick:self.titleButtons[index]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goADDetail:(NSNotification *)note{

    JXHWKWebViewController * webView = [[JXHWKWebViewController alloc]init];
    
    webView.url = note.userInfo[adImageLink];
    
    webView.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:webView animated:YES];
    
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
