//
//  GuidePageVC.m
//  能量圈
//
//  Created by 王斌 on 2017/6/27.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETGuidePageVC.h"
#import <WebKit/WebKit.h>

@interface ETGuidePageVC () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UIButton *enter;

@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;

@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;

@end

@implementation ETGuidePageVC

- (instancetype)init {
    if (self = [super init]) {
        _guidePageType = ETGuidePageNormal;
        _showPageControl = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)updateViewConstraints {
    WS(weakSelf)
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view).with.offset(-30);
        make.bottom.equalTo(weakSelf.view).with.offset(-20);
    }];
    
    [self.enter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.height.equalTo(weakSelf.view.mas_height).multipliedBy(0.25);
    }];
    
    [super updateViewConstraints];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)et_addSubviews {
    switch (self.guidePageType) {
        case ETGuidePageNormal: {
            [self.view addSubview:self.scrollView];
        }
            break;
        case ETGuidePageGif: {
            self.view = self.webView;
            [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
            [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
        }
            break;
        default:
            break;
    }
    [self.view addSubview:self.enter];
    [self.view addSubview:self.pageControl];
    
    [self setGuideImageWithIndex:0];
//    [self setGuideGifImageWithIndex:0];
    
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        if ((self.currentIndex + 1) != self.pageArray.count) {
            [self setGuideGifImageWithIndex:self.currentIndex + 1];
        }
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        if (self.currentIndex) {
            [self setGuideGifImageWithIndex:self.currentIndex - 1];
        }
    }
}

- (void)setGuideImageWithIndex:(NSInteger)index {
    self.currentIndex = index;
    self.pageControl.currentPage = index;
    self.enter.hidden = (index + 1) != self.pageArray.count;
    self.scrollView.contentSize = CGSizeMake(ETScreenW * self.pageArray.count, ETScreenH);
    for (int i = 0; i < self.pageArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ETScreenW * i, 0, ETScreenW, ETScreenH)];
        [imageView setImage:[UIImage imageNamed:self.pageArray[i]]];
        imageView.userInteractionEnabled = YES;
        [self.scrollView addSubview:imageView];
    }
}

- (void)setGuideGifImageWithIndex:(NSInteger)index {
    self.currentIndex = index;
    self.pageControl.currentPage = index;
    self.enter.hidden = (index + 1) != self.pageArray.count;
    NSString *path = [[NSBundle mainBundle] pathForResource:self.pageArray[index] ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    [self.webView loadData:data MIMEType:@"image/gif" characterEncodingName:@"UTF-8" baseURL:[NSURL fileURLWithPath:NSTemporaryDirectory()]];
}

#pragma mark -- lazyLoad --

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:ETScreenB];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO; // 取消反弹
    }
    return _scrollView;
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        [(UIScrollView *)[[_webView subviews] objectAtIndex:0] setBounces:NO];
    }
    return _webView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.hidden = !self.showPageControl;
        _pageControl.numberOfPages = self.pageArray.count;
        _pageControl.pageIndicatorTintColor = [ETWhiteColor colorWithAlphaComponent:0.1];
        _pageControl.currentPageIndicatorTintColor = [ETWhiteColor colorWithAlphaComponent:0.3];
    }
    return _pageControl;
}

- (UIButton *)enter {
    if (!_enter) {
        _enter = [[UIButton alloc] init];
        @weakify(self)
        [[_enter rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self.pageSubject sendNext:nil];
        }];
    }
    return _enter;
}

- (UISwipeGestureRecognizer *)leftSwipeGestureRecognizer {
    if (!_leftSwipeGestureRecognizer) {
        _leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
        _leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    }
    return _leftSwipeGestureRecognizer;
}

- (UISwipeGestureRecognizer *)rightSwipeGestureRecognizer {
    if (!_rightSwipeGestureRecognizer) {
        _rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
        _rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    }
    return _rightSwipeGestureRecognizer;
}

- (RACSubject *)pageSubject {
    if (!_pageSubject) {
        _pageSubject = [RACSubject subject];
    }
    return _pageSubject;
}

#pragma mark -- UIScrollViewDelegate --

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentPage = scrollView.contentOffset.x / ETScreenW;
    self.pageControl.currentPage = currentPage;
    self.enter.hidden = (currentPage + 1) != self.pageArray.count;
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
