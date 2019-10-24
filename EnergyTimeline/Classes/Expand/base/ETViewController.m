//
//  ETViewController.m
//  能量圈
//
//  Created by 王斌 on 2017/5/3.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewController.h"

extern NSString * const ETTableViewDidLeaveFromTopNotification;

@interface ETViewController () <UIScrollViewDelegate>

@end

@implementation ETViewController

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    ETViewController *viewController = [super allocWithZone:zone];
    
    @weakify(viewController)
    [[viewController rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
       @strongify(viewController)
        [viewController et_addSubviews];
        [viewController et_bindViewModel];
    }];
    
    [[viewController rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
        @strongify(viewController)
        [viewController et_layoutNavigation];
        [viewController et_getNewData];
    }];
    
    [[viewController rac_signalForSelector:@selector(viewDidAppear:)] subscribeNext:^(id x) {
        @strongify(viewController)
        [viewController et_didAppear];
    }];
    
    [[viewController rac_signalForSelector:@selector(viewWillDisappear:)] subscribeNext:^(id x) {
        @strongify(viewController)
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [viewController et_willDisappear];
    }];
    
    [[viewController rac_signalForSelector:@selector(viewDidDisappear:)] subscribeNext:^(id x) {
        @strongify(viewController)
        [viewController et_didDisappear];
    }];
    
    return viewController;
}

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    if (self = [super init]) {}
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    /// 利用通知可以同时修改所有的子控制器的scrollView的contentOffset为CGPointZero
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leaveFromTop) name:ETTableViewDidLeaveFromTopNotification object:nil];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)leaveFromTop {
    _basicScrollView.contentOffset = CGPointZero;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!_basicScrollView) {
        _basicScrollView = scrollView;
    }
    
    if (self.scrollDelegate && [self.scrollDelegate respondsToSelector:@selector(scrollViewIsScrolling:)]) {
        [self.scrollDelegate scrollViewIsScrolling:scrollView];
    }
}


#pragma mark - 左边button-文字
- (void)setupLeftNavBarWithTitle:(NSString *)title {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:title
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(leftAction)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}
#pragma mark - 左边button-图片
- (void)setupLeftNavBarWithimage:(NSString *)imageName {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    /**
     *  设置frame只能控制按钮的大小
     */
    btn.frame= CGRectMake(0, 0, 30, 40);
    
    [btn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}
#pragma mark - 左边button-响应事件
- (void)leftAction {
    
}

#pragma mark - 右边button-文字
- (void)setupRightNavBarWithTitle:(NSString *)title {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:title
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(rightAction)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}
#pragma mark - 右边button-图片
- (void)setupRightNavBarWithimage:(NSString *)imageName {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(rightAction)];
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
}
#pragma mark - 右边button-响应事件
- (void)rightAction {
    
}

- (void)resetNavigation {
    [self navBar_show];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = ETClearColor;
    self.navigationController.navigationBar.layer.shadowColor = ETClearColor.CGColor;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)navBar_hidden {
    [self barBackgroundStatus:YES];
}

- (void)navBar_show {
    [self barBackgroundStatus:NO];
}

- (void)barBackgroundStatus:(BOOL)status {
    [self.navigationController.navigationBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // iOS10之后是_UIBarBackground,iOS10之前是_UINavigationBarBackground
        if ([obj isKindOfClass:NSClassFromString(@"_UIBarBackground")]||[obj isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
            
            obj.hidden = status;
        }
    }];
}

#pragma mark - 动态计算行高
//根据字符串的实际内容的多少,在固定的宽度和字体的大小,动态的计算出实际的高度
- (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size {
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    //返回计算出的行高
    return rect.size.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -- RAC --

/** 添加控件 */
- (void)et_addSubviews {}
/** 绑定RAC */
- (void)et_bindViewModel {}
/** 设置navigation */
- (void)et_layoutNavigation {}
/** 初次获取数据 */
- (void)et_getNewData {}
/** 视图已经出现 */
- (void)et_didAppear {}
/** 即将消失时 */
- (void)et_willDisappear {}
/** 视图不可见时 */
- (void)et_didDisappear {}

@end
