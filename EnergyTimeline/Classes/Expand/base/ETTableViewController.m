//
//  ETTableViewController.m
//  能量圈
//
//  Created by 王斌 on 2017/5/3.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETTableViewController.h"

@interface ETTableViewController ()

@end

@implementation ETTableViewController

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    ETTableViewController *tableViewController = [super allocWithZone:zone];
    
    @weakify(tableViewController)
    [[tableViewController rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
        @strongify(tableViewController)
        [tableViewController et_addSubviews];
        [tableViewController et_bindViewModel];
    }];
    
    [[tableViewController rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
        @strongify(tableViewController)
        [tableViewController et_layoutNavigation];
        [tableViewController et_getNewData];
    }];
    
    [[tableViewController rac_signalForSelector:@selector(viewWillDisappear:)] subscribeNext:^(id x) {
        @strongify(tableViewController)
        [tableViewController et_willDisappear];
    }];
    
    return tableViewController;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - 左边button-文字
- (void)setupLeftNavBarWithTitle:(NSString *)title {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:title
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(leftAction)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}
#pragma mark - 左边button-图片
- (void)setupLeftNavBarWithimage:(NSString *)imageName {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    /**
     *  设置frame只能控制按钮的大小
     */
    btn.frame= CGRectMake(0, 0, 30, 30);
    
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
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = ETClearColor;
    self.navigationController.navigationBar.layer.shadowColor = ETClearColor.CGColor;
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

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
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
/** 即将消失时 */
- (void)et_willDisappear {}

@end
