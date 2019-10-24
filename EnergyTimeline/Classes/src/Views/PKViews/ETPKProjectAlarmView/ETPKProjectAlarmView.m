//
//  ETPKProjectAlarmView.m
//  能量圈
//
//  Created by 王斌 on 2018/1/24.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETPKProjectAlarmView.h"
#import "ETPKProjectAlarmViewModel.h"
#import "ETPKProjectAlarmCollectionViewCell.h"

@interface ETPKProjectAlarmView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) UIView *remindView;

@property (nonatomic, strong) UILabel *remindLabel;

@property (nonatomic, strong) UISwitch *remindSwitch;

@property (nonatomic, strong) UIPickerView *timePicker;

@property (nonatomic, strong) UICollectionView *mainCollectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) UILabel *bottomRemindLabel;

@property (nonatomic, strong) ETPKProjectAlarmViewModel *viewModel;

@end

@implementation ETPKProjectAlarmView

- (void)updateConstraints {
    WS(weakSelf)
    
    [self.remindView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).with.offset(10);
        make.left.right.equalTo(weakSelf);
        make.height.equalTo(@64);
    }];
    
    [self.remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.remindView).with.offset(15);
        make.centerY.equalTo(weakSelf.remindView);
    }];
    
    [self.remindSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.remindView).with.offset(-15);
        make.centerY.equalTo(weakSelf.remindView);
    }];
    
    [self.timePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf.remindView.mas_bottom).with.offset(30);
        make.height.equalTo(@180);
    }];
    
    [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(weakSelf);
        make.left.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf.timePicker.mas_bottom).with.offset(30);
        make.height.equalTo(@50);
    }];
    
    [self.bottomRemindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf.mainCollectionView.mas_bottom);
        make.height.equalTo(@20);
    }];
    
    [super updateConstraints];
}

#pragma mark -- private --

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETPKProjectAlarmViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_setupViews {
    [self addSubview:self.remindView];
    [self.remindView addSubview:self.remindLabel];
    [self.remindView addSubview:self.remindSwitch];
    [self addSubview:self.timePicker];
    [self addSubview:self.mainCollectionView];
    [self addSubview:self.bottomRemindLabel];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    [self.viewModel.refreshDataCommand execute:nil];
    
    @weakify(self)
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self)
        [self.remindSwitch setOn:[self.viewModel.model.Is_Enabled boolValue]];
        if (![self.viewModel.model.RemindTime isEqualToString:@""]) {
            NSArray *array = [self.viewModel.model.RemindTime componentsSeparatedByString:@":"];
            [self.timePicker selectRow:[array[0] integerValue] inComponent:0 animated:NO];
            [self.timePicker selectRow:[array[1] integerValue] inComponent:2 animated:NO];
            self.viewModel.hour = array[0];
            self.viewModel.minute = array[1];
        }
//        self.timePicker.hidden = !self.viewModel.isOpen;
//        self.mainCollectionView.hidden = !self.viewModel.isOpen;
//        self.bottomRemindLabel.hidden = !self.viewModel.isOpen;
        [self.mainCollectionView reloadData];
    }];
}

#pragma mark -- lazyLoad --

- (UIView *)remindView {
    if (!_remindView) {
        _remindView = [[UIView alloc] init];
        _remindView.backgroundColor = ETMinorBgColor;
    }
    return _remindView;
}

- (UILabel *)remindLabel {
    if (!_remindLabel) {
        _remindLabel = [[UILabel alloc] init];
        _remindLabel.text = @"提醒";
        _remindLabel.textColor = ETTextColor_Second;
        _remindLabel.font = [UIFont systemFontOfSize:14];
    }
    return _remindLabel;
}

- (UISwitch *)remindSwitch {
    if (!_remindSwitch) {
        _remindSwitch = [[UISwitch alloc] init];
        _remindSwitch.onTintColor = ETMarkYellowColor;
        _remindSwitch.tintColor = ETGrayColor;
//        _remindSwitch.thumbTintColor = ETGrayColor;
        @weakify(self)
        [[_remindSwitch rac_newOnChannel] subscribeNext:^(id value) {
            @strongify(self)
            self.viewModel.isOpen = [value boolValue];
//            self.timePicker.hidden = !self.viewModel.isOpen;
//            self.mainCollectionView.hidden = !self.viewModel.isOpen;
//            self.bottomRemindLabel.hidden = !self.viewModel.isOpen;
            [self.mainCollectionView reloadData];
        }];
    }
    return _remindSwitch;
}

- (UIPickerView *)timePicker {
    if (!_timePicker) {
        _timePicker = [[UIPickerView alloc] init];
        _timePicker.delegate = self;
        _timePicker.dataSource = self;
//        _timePicker.hidden = YES;
    }
    return _timePicker;
}

- (UICollectionView *)mainCollectionView {
    if (!_mainCollectionView) {
        _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.allowsMultipleSelection = YES;
        _mainCollectionView.backgroundColor = ETClearColor;
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
//        _mainCollectionView.hidden = YES;

        
        [_mainCollectionView registerNib:NibName(ETPKProjectAlarmCollectionViewCell) forCellWithReuseIdentifier:ClassName(ETPKProjectAlarmCollectionViewCell)];
    }
    return _mainCollectionView;
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing = 5;
        _layout.minimumInteritemSpacing = 0;
        CGFloat itemWidth = (ETScreenW - 40) / 7;
        _layout.itemSize = CGSizeMake(itemWidth, (itemWidth * 7) / 9);
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _layout;
}

- (UILabel *)bottomRemindLabel {
    if (!_bottomRemindLabel) {
        _bottomRemindLabel = [[UILabel alloc] init];
        _bottomRemindLabel.text = @"打卡后当天将不再提醒";
        _bottomRemindLabel.textColor = ETMinorColor;
        _bottomRemindLabel.font = [UIFont systemFontOfSize:12];
        _bottomRemindLabel.textAlignment = NSTextAlignmentCenter;
//        _bottomRemindLabel.hidden = YES;
    }
    return _bottomRemindLabel;
}

- (ETPKProjectAlarmViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETPKProjectAlarmViewModel alloc] init];
    }
    return _viewModel;
}


#pragma mark -- UIPickerViewDelegate --

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
            self.viewModel.hour = self.viewModel.hours[row];
            break;
        case 2:
            self.viewModel.minute = self.viewModel.minutes[row];
            break;
        default:
            break;
    }
}

#pragma mark -- UIPickerViewDataSource --

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return component ? (component == 1 ? 1 : self.viewModel.minutes.count) : self.viewModel.hours.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 60;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *pickerLabel = [[UILabel alloc] init];
    [pickerLabel setTextAlignment:NSTextAlignmentCenter];
    pickerLabel.textColor = ETTextColor_First;
    pickerLabel.font = [UIFont systemFontOfSize:40 weight:UIFontWeightBold];
    pickerLabel.text = component ? (component == 1 ? @":" : self.viewModel.minutes[row]) : self.viewModel.hours[row];;
    return pickerLabel;
    
}

#pragma mark -- UICollectionView Delegate and Datascoure --

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ETPKProjectAlarmCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ClassName(ETPKProjectAlarmCollectionViewCell) forIndexPath:indexPath];
    cell.weekLabel.text = self.viewModel.weeks[indexPath.row];
    cell.userInteractionEnabled = self.viewModel.isOpen;
    cell.state = ETPKProjectAlarmStateUnCheck;
    for (NSString *string in self.viewModel.selectWeekArray) {
        if ([string isEqualToString:[NSString stringWithFormat:@"%d", indexPath.row]]) {
            [cell setSelected:YES];
            [self.mainCollectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            cell.state = ETPKProjectAlarmStateCheck;
        }
    }
    if (!self.viewModel.isOpen) {
        cell.state = ETPKProjectAlarmStateDisable;
    }
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ETPKProjectAlarmCollectionViewCell *cell = (ETPKProjectAlarmCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self.viewModel.selectWeekArray addObject:[NSString stringWithFormat:@"%d", indexPath.row]];
    cell.state = ETPKProjectAlarmStateCheck;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    ETPKProjectAlarmCollectionViewCell *cell = (ETPKProjectAlarmCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    for (NSString *string in self.viewModel.selectWeekArray) {
        if ([string isEqualToString:[NSString stringWithFormat:@"%d", indexPath.row]]) {
            [self.viewModel.selectWeekArray removeObject:string];
            cell.state = ETPKProjectAlarmStateUnCheck;
            return;
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
