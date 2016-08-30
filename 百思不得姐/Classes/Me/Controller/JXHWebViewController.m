//
//  JXHWebViewController.m
//  百思不得姐
//
//  Created by juxiaohui on 16/8/23.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "JXHWebViewController.h"

@interface JXHWebViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *back;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forward;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refresh;

@end

@implementation JXHWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}
- (IBAction)back:(UIBarButtonItem *)sender {
    
    [self.webView goBack];
}
- (IBAction)forward:(UIBarButtonItem *)sender {
    
    [self.webView goForward];
}
- (IBAction)refresh:(id)sender {
    
    [self.webView reload];
}


-(void)webViewDidFinishLoad:(UIWebView *)webView{

    self.back.enabled = webView.canGoBack;
    
    self.forward.enabled = webView.canGoForward;
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
