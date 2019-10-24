//
//  ETReportPKTableViewCellViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/8/3.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "ETPKProjectModel.h"

@interface ETReportPKTableViewCellViewModel : ETViewModel

@property (nonatomic, strong) ETPKProjectModel *model;

@property (nonatomic, strong) RACSubject *textFiledSubject;

@end
