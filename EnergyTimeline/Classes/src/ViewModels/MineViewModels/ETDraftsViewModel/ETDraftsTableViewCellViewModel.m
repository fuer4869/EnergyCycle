//
//  ETDraftsTableViewCellViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/6/23.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETDraftsTableViewCellViewModel.h"

@implementation ETDraftsTableViewCellViewModel

- (RACSubject *)resendSubject {
    if (!_resendSubject) {
        _resendSubject = [RACSubject subject];
    }
    return _resendSubject;
}

@end
