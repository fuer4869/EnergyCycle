//
//  ETReportPKVC.m
//  能量圈
//
//  Created by 王斌 on 2017/5/25.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETReportPKVC.h"
#import "ETReportPKView.h"
#import "ETReportPKViewModel.h"

#import "ECPickerController.h"

#import "ProjectVC.h"
#import "ETSearchProjectVC.h"

#import "ETProjectVC.h"

#import "ETReportPKCompletedVC.h"
#import "ETNavigationController.h"

#import "ETRewardView.h"

#import "ETBadgeView.h"

@interface ETReportPKVC () <UINavigationControllerDelegate, ECPickerControllerDelegate>

@property (nonatomic, strong) ETReportPKView *mainView;

@property (nonatomic, strong) ETReportPKViewModel *viewModel;

@property (nonatomic, strong) ECPickerController *picker;

@end

@implementation ETReportPKVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ETProjectRelatedBGColor;
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
    
    
    [[self.viewModel.projectSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
//        ProjectVC *projectVC = [[ProjectVC alloc] init];
//        projectVC.type = 1;
//        [projectVC.projectSubject subscribeNext:^(ETPKProjectModel *model) {
//            @strongify(self)
//            self.viewModel.projectModel = model;
//            [self.viewModel.reloadSubject sendNext:nil];
//        }];
        
//        ETProjectVC *projectVC = [[ETProjectVC alloc] init];
//        [projectVC.viewModel.selectArray setArray:self.viewModel.selectProjectArray];
//        [projectVC.viewModel.selectProjectSubject subscribeNext:^(NSMutableArray *array) {
//            @strongify(self)
//            [self.viewModel.selectProjectArray removeAllObjects];
//            [self.viewModel.selectProjectArray setArray:array];
//            [self.viewModel.projectNumArray removeAllObjects];
//            [self.viewModel.reloadSubject sendNext:nil];
//        }];
        
        
        ETSearchProjectVC *projectVC = [[ETSearchProjectVC alloc] init];
        [projectVC.viewModel.selectArray setArray:self.viewModel.selectProjectArray];
        [projectVC.viewModel.selectProjectSubject subscribeNext:^(NSMutableArray *array) {
            @strongify(self)
            [self.viewModel.selectProjectArray removeAllObjects];
            [self.viewModel.selectProjectArray setArray:array];
            [self.viewModel.projectNumArray removeAllObjects];
            [self.viewModel.reloadSubject sendNext:nil];
        }];
        
        [self.navigationController pushViewController:projectVC animated:YES];
    }];
    
    [[self.viewModel.pickerSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self.picker.imageIDArr setArray:self.viewModel.imageIDArray];
        [self presentViewController:self.picker animated:YES completion:nil];
//        ETReportPKCompletedVC *pk = [[ETReportPKCompletedVC alloc] init];
//        [self.navigationController pushViewController:pk animated:YES];
    }];
    
    [[self.viewModel.dismissSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self leftAction];
    }];
    
    [[self.viewModel.reportCompletedSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id responseObject) {
        @strongify(self)
        NSMutableArray *badgeModels = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"Data"][@"_Badge"]) {
            ETBadgeModel *model = [[ETBadgeModel alloc] initWithDictionary:dic error:nil];
            [badgeModels addObject:model];
        }
        NSMutableArray *praiseModels = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"Data"][@"_Praise"]) {
            ETPraiseModel *model = [[ETPraiseModel alloc] initWithDictionary:dic error:nil];
            [praiseModels addObject:model];
        }
        CGFloat duration = 0.f;
        if ([responseObject[@"Data"][@"Integral"] integerValue]) {
            duration = 2.0;
            NSString *content = [NSString stringWithFormat:@"%@积分", responseObject[@"Data"][@"Integral"]];
            NSString *extra = [NSString stringWithFormat:@"恭喜你，额外获得了%@积分", responseObject[@"Data"][@"RewardIntegral"]];
            if (badgeModels.count || praiseModels.count) {
                if ([responseObject[@"Data"][@"RewardIntegral"] integerValue]) {
                    duration += 1;
                    [ETRewardView rewardViewWithContent:content extra:extra duration:duration audioType:ETAudioTypeGetBadge];
                } else {
                    [ETRewardView rewardViewWithContent:content duration:duration audioType:ETAudioTypeGetBadge];
                }
            } else {
                if ([responseObject[@"Data"][@"RewardIntegral"] integerValue]) {
                    duration += 1;
                    [ETRewardView rewardViewWithContent:content extra:extra duration:duration audioType:ETAudioTypeReportPK];
                } else {
                    [ETRewardView rewardViewWithContent:content duration:duration audioType:ETAudioTypeReportPK];
                }
            }
        }
        [NSTimer jk_scheduledTimerWithTimeInterval:duration block:^{
//            NSMutableArray *models = [NSMutableArray array];
//            for (NSDictionary *dic in responseObject[@"Data"][@"_Badge"]) {
//                ETBadgeModel *model = [[ETBadgeModel alloc] initWithDictionary:dic error:nil];
//                [models addObject:model];
//            }
            if (praiseModels.count) {
                [ETBadgeView getPraiseViewWithModels:praiseModels];
            }
            if (badgeModels.count) {
                [ETBadgeView getBadgeViewWithModels:badgeModels];
            }
        } repeats:NO];
        ETReportPKCompletedVC *pk = [[ETReportPKCompletedVC alloc] init];
        [self.navigationController pushViewController:pk animated:YES];
    }];
}

- (void)et_layoutNavigation {
    [MobClick beginLogPageView:@"ETReportPKVC"];

//    self.title = self.viewModel.projectModel.ProjectName ? self.viewModel.projectModel.ProjectName : @"发布每日PK";
    self.title = @"发布每日PK";
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationController.navigationBar.translucent = YES;
    [self setupLeftNavBarWithimage:ETGrayBack];
}

- (void)leftAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)et_willDisappear {
    [MobClick endLogPageView:@"ETReportPKVC"];
    [self resetNavigation];
}

#pragma mark -- lazyLoad --

- (ETReportPKView *)mainView {
    if (!_mainView) {
        _mainView = [[ETReportPKView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETReportPKViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETReportPKViewModel alloc] init];
    }
    return _viewModel;
}

- (ECPickerController *)picker {
    if (!_picker) {
        _picker = [[ECPickerController alloc] init];
        _picker.imageMaxCount = 1;
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
    [self.viewModel.reloadCollectionViewSubject sendNext:nil];
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
