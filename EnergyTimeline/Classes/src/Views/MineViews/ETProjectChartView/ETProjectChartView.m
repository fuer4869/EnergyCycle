//
//  ETProjectChartView.m
//  能量圈
//
//  Created by 王斌 on 2017/8/7.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETProjectChartView.h"
#import "ETProjectChartViewModel.h"
#import "ETProjectChartViewCell.h"

#import <Charts/Charts-Swift.h>

static NSString * const noData = @"noData";

@interface ETProjectChartView () <UITableViewDataSource, UITableViewDelegate, ChartViewDelegate, IChartAxisValueFormatter>

@property (nonatomic, strong) LineChartView *chartView; // 图表控件

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) UIImageView *noDataImageView; // 无数据图片

@property (nonatomic, strong) UIView *selectView; // 选择的项目View

@property (nonatomic, strong) UIImageView *selectProjectImageView;

@property (nonatomic, strong) UILabel *selectProjectNameLabel;

@property (nonatomic, strong) UILabel *selectProjectReportFreLabel;

@property (nonatomic, strong) UILabel *selectProjectUnitLabel;

@property (nonatomic, strong) LineChartDataSet *dataSet; // 数据曲线

@property (nonatomic, strong) ChartLimitLine *llXAxis; // 最大值的高亮线

@property (nonatomic, strong) UILabel *markerLabel; // 点击高亮框内的label

@property (nonatomic, strong) ETProjectChartViewModel *viewModel;

@end

@implementation ETProjectChartView

- (void)updateConstraints {
    WS(weakSelf)
    
    [self.noDataImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
    }];
    
    [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(weakSelf);
        make.height.equalTo(@(ETScreenH * 0.3));
    }];
    
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.chartView.mas_bottom);
        make.left.right.equalTo(weakSelf);
        make.height.equalTo(@60);
    }];
    
    [self.selectProjectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.selectView);
        make.left.equalTo(@20);
        make.top.equalTo(@12);
        make.bottom.equalTo(@-12);
        make.width.equalTo(weakSelf.selectProjectImageView.mas_height);
    }];
    
    [self.selectProjectNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.selectView);
        make.left.equalTo(weakSelf.selectProjectImageView.mas_right).with.offset(15);
    }];
    
    [self.selectProjectReportFreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.selectView);
        make.right.equalTo(@-40);
    }];
    
    [self.selectProjectUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.selectProjectReportFreLabel.mas_bottom);
        make.left.equalTo(weakSelf.selectProjectReportFreLabel.mas_right).with.offset(6);
    }];
    
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.selectView.mas_bottom);
        make.left.right.bottom.equalTo(weakSelf);
    }];
    
    [super updateConstraints];
}

#pragma mark -- private --

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETProjectChartViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_setupViews {
    [self addSubview:self.noDataImageView];
    [self addSubview:self.chartView];
    [self addSubview:self.selectView];
    [self.selectView addSubview:self.selectProjectImageView];
    [self.selectView addSubview:self.selectProjectNameLabel];
    [self.selectView addSubview:self.selectProjectReportFreLabel];
    [self.selectView addSubview:self.selectProjectUnitLabel];
    [self addSubview:self.mainTableView];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    @weakify(self)
    
    [self.viewModel.refreshProjectDataCommand execute:nil];
    
    [self.viewModel.refreshProjectEndSubject subscribeNext:^(id x) {
        @strongify(self)
        if (self.viewModel.projectDataArray.count) {
            self.chartView.hidden = NO;
            self.mainTableView.hidden = NO;
            self.selectView.hidden = NO;
            self.noDataImageView.hidden = YES;
            [self.viewModel.refreshDataCommand execute:nil];
        }
//        [self updateSelectdProject];
//        [self.mainTableView reloadData];
    }];
    
    [self.viewModel.refreshFirstEndSubject subscribeNext:^(id x) {
        @strongify(self)
        NSMutableArray *dataArr = [[NSMutableArray alloc] init];
        [dataArr addObject:self.dataSet];
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataArr];
        [_chartView setData:data];
        
        LineChartDataSet *set1 = (LineChartDataSet *)_chartView.data.dataSets[0];
        set1.values = self.viewModel.dataArr; // 更新数据
        [_chartView.data notifyDataChanged]; // 通知数据源改变
        [_chartView notifyDataSetChanged]; // 通知数据曲线改变
        
        [_chartView setVisibleXRangeMaximum:6]; // 设置X轴最多显示个数
        [_chartView setVisibleXRangeMinimum:6]; // 设置X轴最少显示个数
        self.viewModel.maximum = self.viewModel.maximum ? self.viewModel.maximum : 10; // 如果获取的最大值为0则设置最大值为10,避免最大值为0
        _chartView.leftAxis.axisMaximum = self.viewModel.maximum * 1.01; // 设置y轴最大值
        _chartView.leftAxis.axisMinimum = - self.viewModel.maximum / 10; // 设置y轴最小值

        self.llXAxis.limit = self.viewModel.maximumIndex; // 给限制线赋值数据更新后的最大值索引
        [_chartView.xAxis addLimitLine:self.llXAxis]; // 添加限制线
        
        [_chartView moveViewToX:self.viewModel.dataArr.count - 7];
        
        self.markerLabel.text = [NSString stringWithFormat:@"%ld", (long)self.viewModel.selectedIndexY];
        [_chartView highlightValueWithX:self.viewModel.selectedIndexX y:self.viewModel.selectedIndexY dataSetIndex:0 callDelegate:NO];
        
        self.viewModel.isRequestData = NO;
        
        [self updateSelectdProject];
        [self.mainTableView reloadData];
    }];
    
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self)
        LineChartDataSet *set1 = nil;
        if (_chartView.data.dataSetCount > 0)
        {
            set1 = (LineChartDataSet *)_chartView.data.dataSets[0];
            set1.values = self.viewModel.dataArr;
            
            [_chartView.xAxis removeAllLimitLines]; // 删除所有x轴上的限制线
            self.llXAxis.limit = self.viewModel.maximumIndex; // 给限制线赋值数据更新后的最大值索引
            [_chartView.xAxis addLimitLine:self.llXAxis]; // 重新添加限制线
            [_chartView.data notifyDataChanged]; // 通知数据源改变
            [_chartView notifyDataSetChanged]; // 通知数据曲线改变
            [_chartView setVisibleXRangeMaximum:6]; // 重新设置x轴最多显示个数
            [_chartView setVisibleXRangeMinimum:6]; // 重新设置x轴最少显示个数
            if (!self.viewModel.isAllData) {
                [_chartView moveViewToX:20]; // 移动到指定位置
            }
            
            self.markerLabel.text = [NSString stringWithFormat:@"%ld", (long)self.viewModel.selectedIndexY];
            [_chartView highlightValueWithX:self.viewModel.selectedIndexX y:self.viewModel.selectedIndexY dataSetIndex:0 callDelegate:NO]; // 重新定位选中位置
        }
        self.viewModel.isRequestData = NO;

    }];
}

- (void)updateSelectdProject {
    [self.selectProjectImageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.selectedProjectViewModel.model.FilePath]];
    self.selectProjectNameLabel.text = self.viewModel.selectedProjectViewModel.model.ProjectName;
    self.selectProjectReportFreLabel.text = self.viewModel.selectedProjectViewModel.model.ReportNum;
    self.selectProjectUnitLabel.text = self.viewModel.selectedProjectViewModel.model.ProjectUnit;
    
    /** 事件统计 */
    NSDictionary *dic = @{@"ProjectName" : self.viewModel.selectedProjectViewModel.model.ProjectName};
    [MobClick event:@"ETProjectChartVCClick" attributes:dic];
    
}

#pragma mark -- lazyLoad --

- (UIImageView *)noDataImageView {
    if (!_noDataImageView) {
        _noDataImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noData"]];
    }
    return _noDataImageView;
}

- (UIImageView *)selectProjectImageView {
    if (!_selectProjectImageView) {
        _selectProjectImageView = [[UIImageView alloc] init];
        _selectProjectImageView.layer.cornerRadius = 18;
        _selectProjectImageView.layer.masksToBounds = YES;
//        [_selectProjectImageView jk_setRoundedCorners:UIRectCornerAllCorners radius:18];
//        _selectProjectImageView.layer.shadowColor = ETBlackColor.CGColor;
//        _selectProjectImageView.layer.shadowOpacity = 0.10;
//        _selectProjectImageView.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return _selectProjectImageView;
}

- (UILabel *)selectProjectNameLabel {
    if (!_selectProjectNameLabel) {
        _selectProjectNameLabel = [[UILabel alloc] init];
        _selectProjectNameLabel.textColor = ETTextColor_First;
        _selectProjectNameLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
    }
    return _selectProjectNameLabel;
}

- (UILabel *)selectProjectReportFreLabel {
    if (!_selectProjectReportFreLabel) {
        _selectProjectReportFreLabel = [[UILabel alloc] init];
        _selectProjectReportFreLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightSemibold];
        _selectProjectReportFreLabel.textColor = ETMinorColor;
    }
    return _selectProjectReportFreLabel;
}

- (UILabel *)selectProjectUnitLabel {
    if (!_selectProjectUnitLabel) {
        _selectProjectUnitLabel = [[UILabel  alloc] init];
        _selectProjectUnitLabel.textColor = ETTextColor_First;
        _selectProjectUnitLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightSemibold];
    }
    return _selectProjectUnitLabel;
}

- (UIView *)selectView {
    if (!_selectView) {
        _selectView = [[UIView alloc] init];
        _selectView.backgroundColor = ETMinorBgColor;
        _selectView.hidden = YES;
    }
    return _selectView;
}

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] init];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = ETClearColor;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTableView registerNib:NibName(ETProjectChartViewCell) forCellReuseIdentifier:ClassName(ETProjectChartViewCell)];
        
        _mainTableView.hidden = YES;
    }
    return _mainTableView;
}

- (LineChartView *)chartView {
    if (!_chartView) {
        _chartView = [[LineChartView alloc] init];
        _chartView.delegate = self; // 设置代理
        _chartView.scaleXEnabled = NO; // 取消X轴缩放
        _chartView.scaleYEnabled = NO; // 取消Y轴缩放
        _chartView.leftAxis.enabled = NO; // 不绘制左边轴
        _chartView.rightAxis.enabled = NO; // 不绘制右边轴
        _chartView.legend.enabled = NO; // 不显示图例说明
        _chartView.backgroundColor = ETMinorBgColor;
        _chartView.noDataText = @"正在加载...";
        _chartView.chartDescription.text = @""; // 设置描述文字为空
        _chartView.doubleTapToZoomEnabled = NO; // 取消双击缩放
        _chartView.xAxis.labelPosition = XAxisLabelPositionBottom; // x轴显示在底部
        _chartView.xAxis.drawAxisLineEnabled = NO; // 不绘制x轴心线
        _chartView.xAxis.labelFont = [UIFont systemFontOfSize:8]; // x轴字体大小
        _chartView.xAxis.labelTextColor = ETTextColor_Third; // x轴字体颜色
        _chartView.xAxis.granularity = 1; // 间隔为1
        _chartView.xAxis.gridLineWidth = 1; // 网格线宽度
        _chartView.xAxis.gridColor = [UIColor colorWithHexString:@"#3E3D3D"]; // 网格线颜色
        _chartView.xAxis.gridLineDashLengths = @[@4.0, @2.0]; // 设置虚线样式
        _chartView.xAxis.valueFormatter = self;
        
        ChartMarkerView *marker = [[ChartMarkerView alloc] init];
        marker.chartView = _chartView;
        _chartView.marker = marker;
        [marker addSubview:self.markerLabel];
        
        [_chartView.viewPortHandler restrainViewPortWithOffsetLeft:_chartView.viewPortHandler.offsetLeft offsetTop:_chartView.viewPortHandler.offsetTop offsetRight:_chartView.viewPortHandler.offsetRight - 10 offsetBottom:_chartView.viewPortHandler.offsetBottom];
        
        _chartView.hidden = YES; // 隐藏图表
    }
    return _chartView;
}

- (LineChartDataSet *)dataSet {
    if (!_dataSet) {

        _dataSet = [[LineChartDataSet alloc] initWithValues:self.viewModel.dataArr label:@""];
        
        [_dataSet setColor:ETMinorColor]; // 设置折线颜色
        [_dataSet setCircleColor:ETMinorColor]; // 设置拐点颜色
        _dataSet.drawValuesEnabled = NO; // 不显示文字
        _dataSet.highlightEnabled = YES; // 选中拐点,是否开启高亮效果
        _dataSet.circleRadius = 2.0f; // 拐点半径
        _dataSet.circleHoleRadius = 1.0f; // 拐点空心半径
        _dataSet.circleHoleColor = ETMinorBgColor; // 拐点空心显示的颜色
        _dataSet.drawCircleHoleEnabled = YES; // 绘制拐点中心的空心
        _dataSet.drawHorizontalHighlightIndicatorEnabled = NO;
        
//        _dataSet.highlightColor = [UIColor colorWithHexString:@"FF02EA"];
//        _dataSet.highlightLineWidth = 1; // 高亮线的宽度
//        _dataSet.lineWidth = 0.5;
//        _dataSet.highlightColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:CGRectMake(0, 0, _dataSet.highlightLineWidth, 300) andColors:@[[UIColor colorWithHexString:@"FF3C3C"], [UIColor colorWithHexString:@"FF02EA"]]]; // 高亮线的颜色(渐变色)
        _dataSet.highlightColor = ETClearColor;
        _dataSet.highlightLineDashLengths = @[@4.0, @2.0]; // 给高亮线设置虚线样式
        // 设置渐变效果
//        [_dataSet setColor:[UIColor colorWithRed:0.114 green:0.812 blue:1.000 alpha:1.000]];//折线颜色
        _dataSet.drawFilledEnabled = YES; // 启用颜色填充
        NSArray *gradientColors = @[(id)[ChartColorTemplates colorFromString:@"#00ff0000"].CGColor,
                                    (id)[ChartColorTemplates colorFromString:@"#ffff0000"].CGColor]; // 渐变颜色数组
        CGGradientRef gradientRef = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil); // 渐变参考
        _dataSet.fillAlpha = 1.0; // 填充颜色的透明度
        _dataSet.fill = [ChartFill fillWithLinearGradient:gradientRef angle:90.0f]; // 赋值填充颜色对象
        CGGradientRelease(gradientRef); // 释放gradientRef
    }
    return _dataSet;
}

- (ChartLimitLine *)llXAxis {
    if (!_llXAxis) {
        _llXAxis = [[ChartLimitLine alloc] initWithLimit:0 label:@""];
        _llXAxis.lineWidth = 1.0;
        _llXAxis.lineDashLengths = @[@4.0, @2.0];
        _llXAxis.labelPosition = ChartLimitLabelPositionRightBottom;
        _llXAxis.lineColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:CGRectMake(0, 0, _dataSet.highlightLineWidth, 300) andColors:@[[UIColor colorWithHexString:@"FF3C3C"], [UIColor colorWithHexString:@"FF02EA"]]];
    }
    return _llXAxis;
}

- (UILabel *)markerLabel {
    if (!_markerLabel) {
        _markerLabel = [[UILabel alloc] initWithFrame:CGRectMake(-15, 5, 30, 20)];
        _markerLabel.layer.cornerRadius = 10;
        _markerLabel.layer.masksToBounds = YES;
        _markerLabel.textAlignment = NSTextAlignmentCenter;
        _markerLabel.font = [UIFont systemFontOfSize:10];
        _markerLabel.textColor = ETMinorColor;
        _markerLabel.backgroundColor = ETMainColor;
    }
    return _markerLabel;
}

- (ETProjectChartViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETProjectChartViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark -- TableViewDelegate And DataSource --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.unSelectedProjectArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ETProjectChartViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETProjectChartViewCell) forIndexPath:indexPath];
    cell.viewModel = self.viewModel.unSelectedProjectArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.viewModel.selectedProjectViewModel = self.viewModel.unSelectedProjectArray[indexPath.row];
    [self.viewModel.unSelectedProjectArray removeAllObjects];
    [self.viewModel.unSelectedProjectArray setArray:self.viewModel.projectDataArray];
    [self.viewModel.unSelectedProjectArray removeObject:self.viewModel.selectedProjectViewModel];
    [self.viewModel.refreshDataCommand execute:nil];
}

#pragma mark -- ChartDelegate --

- (void)chartTranslated:(ChartViewBase *)chartView dX:(CGFloat)dX dY:(CGFloat)dY {
    if (chartView.viewPortHandler.transX >= -50 && !self.viewModel.isRequestData && !self.viewModel.isAllData) {
        self.viewModel.isRequestData = YES;
        [self.viewModel.nextPageCommand execute:nil];
    }
}

- (void)chartValueSelected:(ChartViewBase *)chartView entry:(ChartDataEntry *)entry highlight:(ChartHighlight *)highlight {
    self.markerLabel.text = [NSString stringWithFormat:@"%ld", (long)entry.y];
    self.viewModel.selectedIndexX = entry.x;
    self.viewModel.selectedIndexY = entry.y;
}

- (void)chartValueNothingSelected:(ChartViewBase * _Nonnull)chartView {
    
}

- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis {
    NSDate *date = [NSDate jk_dateAfterDate:[NSDate date] day:value - (self.viewModel.dataArray.count - 1)];
    if ([date jk_isSameDay:[NSDate date]]) {
        return @"今天";
    }
    return [date jk_stringWithFormat:@"MM/dd"];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
