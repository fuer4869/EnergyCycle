//
//  ETSyncPostTableViewCellViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/5/25.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETSyncPostTableViewCellViewModel.h"

@implementation ETSyncPostTableViewCellViewModel

- (RACSubject *)syncSubject {
    if (!_syncSubject) {
        _syncSubject = [RACSubject subject];
    }
    return _syncSubject;
}

@end
