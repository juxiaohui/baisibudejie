//
//  JXHWKWebViewController.m
//  百思不得姐
//
//  Created by juxiaohui on 16/8/23.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "JXHWKWebViewController.h"
#import <WebKit/WebKit.h>

#define JXHKeyPath(objc,keyPath) @(((void)objc.keyPath,#keyPath))

@interface JXHWKWebViewController ()<WKNavigationDelegate,WKScriptMessageHandler>

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *back;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forward;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refresh;
@property(nonatomic, weak) WKWebView * webView;
@property(nonatomic, weak) UIProgressView * progressView;

@end

@implementation JXHWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupWebView];
    //[self setupProgressView];
}

-(UIProgressView *)progressView{

    if (!_progressView) {
        
        UIProgressView * progressiew = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, 2)];
        progressiew.progress=0.0;
        progressiew.trackTintColor = [UIColor clearColor];
        [self.view addSubview:progressiew];
        
        _progressView = progressiew;
 
    }
    return  _progressView;
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

}

-(void)setupWebView{
    
    // 创建配置
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // 创建UserContentController（提供JavaScript向webView发送消息的方法）
    WKUserContentController* userContent = [[WKUserContentController alloc] init];
    // 添加消息处理，注意：self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
    [userContent addScriptMessageHandler:self name:@"NativeMethod"];
    // 将UserConttentController设置到配置文件
    config.userContentController = userContent;
    // 高端的自定义配置创建WKWebView
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-self.toolbar.jxh_height) configuration:config];
    webView.scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);

    // 根据URL创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    // WKWebView加载请求
    [webView loadRequest:request];
    
    webView =webView;
    
    webView.allowsBackForwardNavigationGestures = YES;
    
    webView.navigationDelegate = self;
    
    [self.view addSubview:webView];
    
    self.webView =webView;
    
    [self.webView addObserver:self forKeyPath:JXHKeyPath(self.webView, estimatedProgress) options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    //[self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        NSLog(@"%@",change);
    
        self.progressView.progress =[change[@"new"] floatValue];
        
        if ([change[@"new"] floatValue]==1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.hidden=YES;
            });
        }
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"didStartProvisionalNavigation");
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"didCommitNavigation");
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"didFinishNavigation");
    
    
    self.back.enabled =self.webView.canGoBack;
    
    self.forward.enabled = self.webView.canGoForward;

}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"didFailNavigation");
    
    //self.progressView.hidden=YES;
}


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    NSLog(@"userContentController");
}
-(void)dealloc{

    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"NativeMethod"];
    
    [self.webView removeObserver:self forKeyPath:JXHKeyPath(self.webView, estimatedProgress)];
}
- (IBAction)back:(UIBarButtonItem *)sender {
    
    [self.webView goBack];
}

- (IBAction)forward:(UIBarButtonItem *)sender {
    
    [self.webView goForward];
}
- (IBAction)refresh:(UIBarButtonItem *)sender {
    
    [self.webView reload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
