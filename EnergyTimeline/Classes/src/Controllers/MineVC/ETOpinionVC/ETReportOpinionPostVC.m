//
//  ETReportOpinionPostVC.m
//  能量圈
//
//  Created by 王斌 on 2017/12/30.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETReportOpinionPostVC.h"
#import "ETReportOpinionPostView.h"
#import "ETReportOpinionPostViewModel.h"

#import "ECPickerController.h"

#import "ETRewardView.h"

#import "ETPopView.h"

@interface ETReportOpinionPostVC () <ECPickerControllerDelegate>

@property (nonatomic, strong) ETReportOpinionPostView *mainView;

@property (nonatomic, strong) ETReportOpinionPostViewModel *viewModel;

@property (nonatomic, strong) ECPickerController *picker;

@end

@implementation ETReportOpinionPostVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ETMainBgColor;
    // Do any additional setup after loading the view from its nib.
}

- (void)updateViewConstraints {
    WS(weakSelf)
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    [super updateViewConstraints];
}

- (void)et_addSubviews {
    [self.view addSubview:self.mainView];
}

- (void)et_bindViewModel {
    
    @weakify(self)
    
    [[self.viewModel.pickerSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self.picker.imageIDArr setArray:self.viewModel.imageIDArray];
        //        self.picker.imageIDArr = self.viewModel.imageIDArray;
//        self.picker.imageMaxCount = 9 - self.viewModel.todayImageIDArray.count;
        [self presentViewController:self.picker animated:YES completion:nil];
    }];
    
    [[self.viewModel.dismissSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id responseObject) {
        @strongify(self)
        NSArray *arr = [responseObject[@"Data"] componentsSeparatedByString:@","];
        if ([arr[1] integerValue]) {
            [ETRewardView rewardViewWithContent:[NSString stringWithFormat:@"+%@积分", arr[1]] duration:2.0 audioType:ETAudioTypeReportPost];
        }
        [self leftAction];
    }];
}

- (void)et_layoutNavigation {
    [MobClick beginLogPageView:@"ETReportPKPoolVC"];
    self.title = @"发帖";
    [self setupLeftNavBarWithimage:ETGrayBack];
    [self setupRightNavBarWithTitle:@"发布"];
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction {
    if (![self.viewModel.postContent isEqualToString:@""] && self.viewModel.postContent) {
        [self.viewModel.reportCommand execute:nil];
    } else {
        [ETPopView popViewWithTip:@"吐槽需要文字"];
    }
}

- (void)et_willDisappear {
    [MobClick endLogPageView:@"ETReportPKPoolVC"];
    [self resetNavigation];
}

#pragma mark -- lazyLoad --

- (ETReportOpinionPostView *)mainView {
    if (!_mainView) {
        _mainView = [[ETReportOpinionPostView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETReportOpinionPostViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETReportOpinionPostViewModel alloc] init];
    }
    return _viewModel;
}

- (ECPickerController *)picker {
    if (!_picker) {
        _picker = [[ECPickerController alloc] init];
        _picker.imageMaxCount = 9;
//        _picker.imageIDArr = self.viewModel.imageIDArray;
        _picker.pickerDelegate = self;
    }
    return _picker;
}

#pragma mark -- delegate --

- (void)exportImageData:(NSArray *)imageData ID:(NSArray *)ID {
    [self.viewModel.selectImgArray removeAllObjects];
    [self.viewModel.imageIDArray removeAllObjects];
    [self.viewModel.selectImgArray addObjectsFromArray:imageData];
    [self.viewModel.imageIDArray addObjectsFromArray:ID];
    [self.viewModel.refreshEndSubject sendNext:nil];
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
