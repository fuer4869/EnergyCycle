//
//  ETCacheView.m
//  能量圈
//
//  Created by 王斌 on 2018/4/23.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETCacheView.h"
#import "ETCacheTableViewCell.h"
#import "CacheManager.h"

#import "ETTrainPopView.h"

@interface ETCacheView () <UITableViewDelegate, UITableViewDataSource, ETTrainPopViewDelegate>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, assign) ETCacheType type;

@end

@implementation ETCacheView

- (void)updateConstraints {
    WS(weakSelf)
    
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [super updateConstraints];
}

#pragma mark -- private --

- (void)et_setupViews {
    [self addSubview:self.mainTableView];
    
    [super setNeedsUpdateConstraints];
    [super updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    
}

#pragma mark -- lazyLoad --

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = ETMinorBgColor;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTableView registerNib:NibName(ETCacheTableViewCell) forCellReuseIdentifier:ClassName(ETCacheTableViewCell)];
    }
    return _mainTableView;
}

#pragma mark -- tableview delegate datasource --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = ETMainBgColor;
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ETCacheTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETCacheTableViewCell) forIndexPath:indexPath];
    cell.cacheType = indexPath.row ? ETCacheTypeImage : ETCacheTypeTrain;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row) {
        self.type = ETCacheTypeImage;
        ETTrainPopView *popView = [[ETTrainPopView alloc] initWithTitle:@"提示" Content:@"本操作将清除图片头像等缓存" LeftBtnTitle:@"取消" RightBtnTitle:@"清除"];
        popView.delegate = self;
        [ETWindow addSubview:popView];
    } else {
        self.type = ETCacheTypeTrain;
        ETTrainPopView *popView = [[ETTrainPopView alloc] initWithTitle:@"提示" Content:@"清除训练音频后,已下载的音频需要重新下载" LeftBtnTitle:@"取消" RightBtnTitle:@"清除"];
        popView.delegate = self;
        [ETWindow addSubview:popView];
    }
}

#pragma mark -- ETTrainPopViewDelegate --

- (void)leftButtonClick:(NSString *)string {
    NSLog(@"取消");
}

- (void)rightButtonClick:(NSString *)string {
    if (self.type == ETCacheTypeImage) {
        NSLog(@"清除图片缓存");
        [CacheManager clearImageCache];
    } else {
        NSLog(@"清除训练缓存");
        [CacheManager clearTrainCache];
    }
    [self.mainTableView reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
