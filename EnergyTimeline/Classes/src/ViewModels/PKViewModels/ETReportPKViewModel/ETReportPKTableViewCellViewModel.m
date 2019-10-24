//
//  ETReportPKTableViewCellViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/8/3.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETReportPKTableViewCellViewModel.h"

@implementation ETReportPKTableViewCellViewModel

- (RACSubject *)textFiledSubject {
    if (!_textFiledSubject) {
        _textFiledSubject = [RACSubject subject];
    }
    return _textFiledSubject;
}

@end
