//
//  ETNoticeCenterVC.m
//  能量圈
//
//  Created by 王斌 on 2017/6/18.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETNoticeCenterVC.h"
#import "ETNoticeCenterViewModel.h"
#import "ZJScrollPageView.h"

#import "ETRemindListVC.h"
#import "ETChatListVC.h"

static NSString * const segmentViewColorHexString = @"E05954";

@interface ETNoticeCenterVC () <ZJScrollPageViewDelegate>

@property (nonatomic, strong) ZJSegmentStyle *style;

@property (nonatomic, strong) ZJScrollSegmentView *segmentView;

@property (nonatomic, strong) ZJContentView *contentView;

@property (nonatomic, strong) ETNoticeCenterViewModel *viewModel;

@end

@implementation ETNoticeCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)updateViewConstraints {
//    WS(weakSelf)
//    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(weakSelf.view);
//    }];
    
    [super updateViewConstraints];
}

- (void)et_addSubviews {
    self.navigationItem.titleView = self.segmentView;
    [self.view addSubview:self.contentView];
}

- (void)et_bindViewModel {
    @weakify(self)
    [self.viewModel.noticeDataCommand execute:nil];
    
    [[self.viewModel.refreshEndSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        if (![self.viewModel.model.NewFriend integerValue] && ![self.viewModel.model.Notice integerValue] && ![self.viewModel.model.Post_Commen integerValue] && ![self.viewModel.model.Post_Like integerValue] && ![self.viewModel.model.Post_MenTion integerValue] && ![self.viewModel.model.Msg integerValue]) {
            [self.segmentView setSelectedIndex:1 animated:YES];
        }
    }];
}

- (void)et_layoutNavigation {
    self.view.backgroundColor = ETMainBgColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationController.navigationBar.layer.shadowColor = ETBlackColor.CGColor;
//    self.navigationController.navigationBar.layer.shadowOpacity = 0.1;
//    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 0);
    [self setupLeftNavBarWithimage:ETLeftArrow_Gray];
}

- (void)et_didDisappear {
    [self resetNavigation];
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- lazyLoad --

- (ZJSegmentStyle *)style {
    if (!_style) {
        _style = [[ZJSegmentStyle alloc] init];
        _style.showCover = YES;
        _style.scrollTitle = NO;
        _style.titleFont = [UIFont systemFontOfSize:12];
        _style.gradualChangeTitleColor = YES; // 开启颜色渐变,但是同时默认字体颜色和选择时字体颜色必须使用RGB颜色,否则程序崩溃
        _style.coverBackgroundColor = [UIColor colorWithHexString:segmentViewColorHexString];
//        _style.normalTitleColor = [UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:77.0/255.0 alpha:1.0];
//        _style.selectedTitleColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
        _style.normalTitleColor = [UIColor jk_colorWithWholeRed:149 green:160 blue:171];
        _style.selectedTitleColor = [UIColor jk_colorWithWholeRed:255 green:255 blue:255];
    }
    return _style;
}

- (ZJScrollSegmentView *)segmentView {
    if (!_segmentView) {
        WS(weakSelf)
        _segmentView = [[ZJScrollSegmentView alloc] initWithFrame:CGRectMake(0, kNavHeight, 140, 30) segmentStyle:self.style delegate:self titles:@[@"提醒", @"私信"] titleDidClick:^(ZJTitleView *titleView, NSInteger index) {
            [weakSelf.contentView setContentOffSet:CGPointMake(weakSelf.contentView.bounds.size.width * index, 0) animated:YES];
        }];
        _segmentView.layer.borderWidth = 1;
        _segmentView.layer.borderColor = [UIColor colorWithHexString:segmentViewColorHexString].CGColor;
        _segmentView.layer.cornerRadius = 15.0;
        _segmentView.backgroundColor = ETMinorBgColor;
    }
    return _segmentView;
}

- (ZJContentView *)contentView {
    if (!_contentView) {
        CGRect frame = ETScreenB;
        frame.size.height -= kNavHeight;
        _contentView = [[ZJContentView alloc] initWithFrame:frame segmentView:self.segmentView parentViewController:self delegate:self];
        _contentView.backgroundColor = ETClearColor;
    }
    return _contentView;
}

- (ETNoticeCenterViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETNoticeCenterViewModel alloc] init];
    }
    return _viewModel;
}

#pragma -- ZJScrollPageViewDelegate --
- (NSInteger)numberOfChildViewControllers {
    return 2;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(ETViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    ETViewController<ZJScrollPageViewChildVcDelegate> *childVC = reuseViewController;
    
    if (!childVC) {
        switch (index) {
            case 0: {
                childVC = [[ETRemindListVC alloc] init];
            }
                break;
            case 1: {
                [MobClick event:@"ChatListClick"];
                childVC = [[ETChatListVC alloc] init];
            }
                break;
            default:
                break;
        }
    }
    return childVC;
}

/** 为了正常显示子视图必须调用这个方法 */
- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
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
