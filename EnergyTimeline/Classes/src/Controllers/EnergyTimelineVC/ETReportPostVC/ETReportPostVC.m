//
//  ETReportPostVC.m
//  能量圈
//
//  Created by 王斌 on 2017/5/30.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETReportPostVC.h"
#import "ETReportPostView.h"

#import "ECPickerController.h"
#import "ETPopView.h"

#import "ETNavigationController.h"
#import "ECContactVC.h"

@interface ETReportPostVC () <UINavigationControllerDelegate, ECPickerControllerDelegate, ETPopViewDelegate, ECContactVCDelegate>

@property (nonatomic, strong) ETReportPostView *mainView;

@property (nonatomic, strong) ECPickerController *picker;

@end

@implementation ETReportPostVC

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

#pragma mark -- private --
- (void)et_addSubviews {
    [self.view addSubview:self.mainView];
}

- (void)et_bindViewModel {
    @weakify(self)
    [[self.viewModel.dismissSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self dismissAcition];
    }];
    
    [[self.viewModel.pickerSubjet takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self.picker.imageIDArr setArray:self.viewModel.imageIDArray];
        [self presentViewController:self.picker animated:YES completion:nil];
    }];
    
    [[self.viewModel.removePictureSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber *number) {
        @strongify(self)
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒" message:@"确认要删除该图片吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.viewModel.selectImgArray removeObjectAtIndex:[number integerValue]];
            [self.viewModel.imageIDArray removeObjectAtIndex:[number integerValue]];
            [self.viewModel.reloadCollectionViewSubject sendNext:nil];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:sureAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    
    [[self.viewModel.contactVCSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        ECContactVC *vc = [[ECContactVC alloc] init];
        vc.delegate = self;
        vc.selectedDatas = self.viewModel.contacts;
        ETNavigationController *nav = [[ETNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }];
    
}

- (void)et_layoutNavigation {
    [MobClick beginLogPageView:@"ETReportPostVC"];
    [self setupLeftNavBarWithTitle:@"取消"];
    [self setupRightNavBarWithTitle:@"发布"];
    self.title = @"动态";
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:ETBlackColor}];
//    self.navigationController.navigationBar.tintColor = ETBlackColor;
}

- (void)leftAction {
    if (self.viewModel.postContent.length || self.viewModel.selectImgArray.count) {
        [ETPopView popViewWithDelegate:self Title:@"保存草稿" Tip:@"是否将当前内容保存到草稿箱" SureBtnTitle:@"确定" CancelBtnTitle:@"取消"];
    } else {
        [self dismissAcition];
    }
}

- (void)dismissAcition {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)popViewClickSureBtn {
    [self.viewModel.saveOrUpdateDraftSubject sendNext:nil];
    [self dismissAcition];
}

- (void)popViewClickCancelBtn {
    [self dismissAcition];
}

- (void)rightAction {
    if (![self.viewModel.postContent isEqualToString:@""]) {
        [self.viewModel.reportCommand execute:nil];
    } else {
        [ETPopView popViewWithTip:@"发帖需要文字"];
    }
}

- (void)et_willDisappear {
    [MobClick endLogPageView:@"ETReportPostVC"];
    [self resetNavigation];
}

#pragma mark -- lazyLoad --

- (ETReportPostView *)mainView {
    if (!_mainView) {
        _mainView = [[ETReportPostView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETReportPostViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETReportPostViewModel alloc] init];
    }
    return _viewModel;
}

- (ECPickerController *)picker {
    if (!_picker) {
        _picker = [[ECPickerController alloc] init];
//        _picker.imageIDArr = self.viewModel.imageIDArray;
        _picker.pickerDelegate = self;
    }
    return _picker;
}

#pragma mark -- ECContactVCDelegate --

- (void)didSelectedContacts:(NSMutableArray *)items {
    self.viewModel.contacts = items;
    self.mainView.alertWhoView.datas = self.viewModel.contacts;
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
