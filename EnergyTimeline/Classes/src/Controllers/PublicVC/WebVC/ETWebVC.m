//
//  ETWebVC.m
//  能量圈
//
//  Created by 王斌 on 2017/6/21.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETWebVC.h"
#import <WebKit/WebKit.h>
#import "ETShareView.h"
#import "ShareSDKManager.h"
#import "ETHomePageVC.h"

static NSString * const back_text_gray = @"back_text_gray";
static NSString * const share_red = @"share_red";

@interface ETWebVC () <WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate, NSURLSessionDelegate, NSURLSessionDataDelegate, ETShareViewDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) WKWebViewConfiguration *config;

@property (nonatomic, strong) NSURL *requestUrl;

@property (nonatomic, strong) NSMutableData *resultData;

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) UIBarButtonItem *backItem;

@property (nonatomic, strong) UIBarButtonItem *closeItem;

@end

@implementation ETWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ETMainBgColor;
    
    self.config = [[WKWebViewConfiguration alloc] init];
    [self.config.userContentController addScriptMessageHandler:self name:@"UserID"];
    [self.config.userContentController addScriptMessageHandler:self name:@"SaveImg"];
    [self.config.userContentController addScriptMessageHandler:self name:@"PersonReport"];

    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:self.config];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.allowsBackForwardNavigationGestures = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    
    self.webView.scrollView.backgroundColor = ETClearColor;
//    self.webView.backgroundColor = ETMainBgColor;
    
    [self.view addSubview:self.webView];
    [self.webView addSubview:self.progressView];

    WS(weakSelf)
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@kNavHeight);
//        make.left.right.bottom.equalTo(weakSelf.view);
        make.edges.equalTo(weakSelf.view);
    }];
    
//    // 使用代理方法需要设置代理,但是session的delegate属性是只读的,要想设置代理只能通过这种方式创建session
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
//                                                          delegate:self
//                                                     delegateQueue:[[NSOperationQueue alloc] init]];
//    
//    // 创建任务(因为要使用代理方法,就不需要block方式的初始化了)
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
//    
//    // 启动任务
//    [task resume];
    // Do any additional setup after loading the view from its nib.
}

- (void)et_addSubviews {
//    self.view = self.webView;
//    [self.webView addSubview:self.progressView];
}

- (void)et_bindViewModel {
    @weakify(self)

    [RACObserve(self.webView, estimatedProgress) subscribeNext:^(id x) {
        @strongify(self)
        self.progressView.progress = self.webView.estimatedProgress;
    }];
}

- (void)et_layoutNavigation {
    if (self.webType == ETWebTypePost) {
        [MobClick beginLogPageView:@"ETWeb_PostVC"];
    } else if (self.webType == ETWebTypeRecommendPost) {
        [MobClick beginLogPageView:@"ETWeb_RecommendPostVC"];
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationController.navigationBar.translucent = YES;
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:ETBlackColor}];
//    self.navigationController.navigationBar.layer.shadowColor = ETBlackColor.CGColor;
//    self.navigationController.navigationBar.layer.shadowOpacity = 0.1;
//    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 0);
    [self.navigationItem setLeftBarButtonItems:@[self.backItem]];
    
    if (self.webType != ETWebTypeAgreement) {
        [self setupRightNavBarWithimage:share_red];
    }
}

- (void)et_willDisappear {
    if (self.webType == ETWebTypePost) {
        [MobClick endLogPageView:@"ETWeb_PostVC"];
    } else if (self.webType == ETWebTypeRecommendPost) {
        [MobClick endLogPageView:@"ETWeb_RecommendPostVC"];
    }
}

- (void)backAction {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    } else {
        if (self.presentingViewController) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)closeAction {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)rightAction {
    [ETShareView shareViewWithBottomWithDelegate:self];
}

- (ETShareModel *)shareModel {
    ETShareModel *shareModel = [[ETShareModel alloc] init];
    shareModel.title = self.webView.title;
    shareModel.content = self.webType == ETWebTypeActivities ? self.webView.title : ([self.model.PostType integerValue] == 5 ? self.model.PostTitle : ([self.model.PostContent isEqualToString:@""] ? @"来自能量圈" : self.model.PostContent));
//    shareModel.content = [self.model.PostType integerValue] == 5 ? self.model.PostTitle : self.model.PostContent;
    shareModel.content = [[shareModel.content stringByRemovingPercentEncoding] jk_stringByStrippingHTML];
    shareModel.imageArray = self.webType == ETWebTypeActivities ? nil : (self.model.FilePath ? @[self.model.FilePath] : nil);
    shareModel.shareUrl = [self.webView.URL absoluteString];
    
    return shareModel;
}

/** QQ空间分享 */
- (void)shareViewClickQzoneBtn {
    NSLog(@"qzone");
    [[ShareSDKManager shareInstance] shareWithShareType:SSDKPlatformSubTypeQZone shareModel:[self shareModel] webImage:nil result:^(SSDKResponseState state) {
        if (state == SSDKResponseStateSuccess) {
            [MBProgressHUD showMessage:@"分享成功"];
        }
    }];
}

/** 微信分享 */
- (void)shareViewClickWechatSessionBtn {
    NSLog(@"wechat");
    [[ShareSDKManager shareInstance] shareWithShareType:SSDKPlatformSubTypeWechatSession shareModel:[self shareModel] webImage:nil result:^(SSDKResponseState state) {
        if (state == SSDKResponseStateSuccess) {
            [MBProgressHUD showMessage:@"分享成功"];
        }
    }];
}

/** 微博分享 */
- (void)shareViewClickSinaWeiboBtn {
    NSLog(@"sina");
    [[ShareSDKManager shareInstance] shareWithShareType:SSDKPlatformTypeSinaWeibo shareModel:[self shareModel] webImage:nil result:^(SSDKResponseState state) {
        if (state == SSDKResponseStateSuccess) {
            [MBProgressHUD showMessage:@"分享成功"];
        }
    }];
}

/** 朋友圈分享 */
- (void)shareViewClickWechatTimelineBtn {
    [[ShareSDKManager shareInstance] shareWithShareType:SSDKPlatformSubTypeWechatTimeline shareModel:[self shareModel] webImage:nil result:^(SSDKResponseState state) {
        if (state == SSDKResponseStateSuccess) {
            [MBProgressHUD showMessage:@"分享成功"];
        }
    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        [MBProgressHUD showMessage:@"保存成功"];
    }
}

#pragma mark -- lazyLoad --

//- (WKWebView *)webView {
//    if (!_webView) {
//        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:self.config];
//        _webView.UIDelegate = self;
//        _webView.navigationDelegate = self;
//    }
//    return _webView;
//}
//
//- (WKWebViewConfiguration *)config {
//    if (!_config) {
//        _config = [[WKWebViewConfiguration alloc] init];
//        [_config.userContentController addScriptMessageHandler:self name:@"UserID"];
//        [_config.userContentController addScriptMessageHandler:self name:@"SaveImg"];
//    }
//    return _config;
//}

- (NSMutableData *)resultData {
    if (!_resultData) {
        _resultData = [[NSMutableData alloc] init];
    }
    return _resultData;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.frame = CGRectMake(0, 0, ETScreenW, 1);
    }
    return _progressView;
}

- (UIBarButtonItem *)backItem {
    if (!_backItem) {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:back_text_gray] forState:UIControlStateNormal];
        backButton.frame = CGRectMake(0, 0, 50, 30);
        [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        _backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    return _backItem;
}

- (UIBarButtonItem *)closeItem {
    if (!_closeItem) {
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor colorWithHexString:@"707070"] forState:UIControlStateNormal];
        [closeButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        closeButton.frame = CGRectMake(0, 0, 30, 30);
        [closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        closeButton.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        _closeItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    }
    return _closeItem;
}

#pragma mark -- WKUIDelegate --

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"UserID"]) {
        NSString *userID = [message.body objectForKey:@"body"];
        ETHomePageVC *homePageVC = [[ETHomePageVC alloc] init];
        homePageVC.viewModel.userID = [userID integerValue];
        [self.navigationController pushViewController:homePageVC animated:YES];
    } else if ([message.name isEqualToString:@"SaveImg"]) {
        NSString *imgUrl = [message.body objectForKey:@"body"];
        [[UIImageView new] sd_setImageWithURL:[NSURL URLWithString:imgUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }];
    } else if ([message.name isEqualToString:@"PersonReport"]) {
        if ([[message.body objectForKey:@"body"] isEqualToString:@"timeline"]) {
            [self shareViewClickWechatTimelineBtn];
        } else if ([[message.body objectForKey:@"body"] isEqualToString:@"weixin"]) {
            [self shareViewClickWechatSessionBtn];
        } else if ([[message.body objectForKey:@"body"] isEqualToString:@"weibo"]) {
            [self shareViewClickSinaWeiboBtn];
        } else if ([[message.body objectForKey:@"body"] isEqualToString:@"QQ"]) {
            [self shareViewClickQQBtn];
        } else if ([[message.body objectForKey:@"body"] isEqualToString:@"Qzone"]) {
            [self shareViewClickQzoneBtn];
        }
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    
}

//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载网页");
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成");
    //加载完成后隐藏progressView
    self.title = self.webView.title;
//    self.webView
    if (self.webView.canGoBack) {
        [self.navigationItem setLeftBarButtonItems:@[self.backItem, self.closeItem]];
    }
    self.progressView.hidden = YES;
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
    //加载失败同样需要隐藏progressView
    self.progressView.hidden = YES;
}

#pragma mark -- NSURLSessionDataDelgate 暂时停用 --

// 接收到服务器的响应
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    // 允许处理服务器的响应，才会继续接收服务器返回的数据
    completionHandler(NSURLSessionResponseAllow);
}

// 接收到服务器的数据（可能调用多次）
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    // 处理每次接收的数据
    [self.resultData appendData:data];
}

// 请求成功或者失败（如果失败，error有值）
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    // 请求完成,成功或者失败的处理
    if (!error) {
        NSString *html = [[NSString alloc] initWithBytes:[self.resultData bytes] length:[self.resultData length] encoding:NSUTF8StringEncoding];
        [self.webView loadHTMLString:html baseURL:[NSURL URLWithString:self.url]];
    }
}

/*
 // 只要访问的是HTTPS的路径就会调用
 // 该方法的作用就是处理服务器返回的证书, 需要在该方法中告诉系统是否需要安装服务器返回的证书
 // NSURLAuthenticationChallenge : 授权质问
 //+ 受保护空间
 //+ 服务器返回的证书类型
 - (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler
 {
 //    NSLog(@"didReceiveChallenge");
 //    NSLog(@"%@", challenge.protectionSpace.authenticationMethod);
 
 // 1.从服务器返回的受保护空间中拿到证书的类型
 // 2.判断服务器返回的证书是否是服务器信任的
 if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
 NSLog(@"是服务器信任的证书");
 // 3.根据服务器返回的受保护空间创建一个证书
 //         void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *)
 //         代理方法的completionHandler block接收两个参数:
 //         第一个参数: 代表如何处理证书
 //         第二个参数: 代表需要处理哪个证书
 //创建证书
 NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
 // 4.安装证书   completionHandler(NSURLSessionAuthChallengeUseCredential , credential);
 }
 }
 */
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    //AFNetworking中的处理方式
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;
    //判断服务器返回的证书是否是服务器信任的
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        /*disposition：如何处理证书
         NSURLSessionAuthChallengePerformDefaultHandling:默认方式处理
         NSURLSessionAuthChallengeUseCredential：使用指定的证书    NSURLSessionAuthChallengeCancelAuthenticationChallenge：取消请求
         */
        if (credential) {
            disposition = NSURLSessionAuthChallengeUseCredential;
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
    } else {
        disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
    }
    //安装证书
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}

#pragma mark - WKNavigationDelegate
// 请求开始前，会先调用此代理方法
// 与UIWebView的
// - (BOOL)webView:(UIWebView *)webView
// shouldStartLoadWithRequest:(NSURLRequest *)request
// navigationType:(UIWebViewNavigationType)navigationType;
// 类型，在请求先判断能不能跳转（请求）
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (!navigationAction.targetFrame) {
        [self.webView loadRequest:navigationAction.request];
        self.progressView.hidden = NO;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
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
