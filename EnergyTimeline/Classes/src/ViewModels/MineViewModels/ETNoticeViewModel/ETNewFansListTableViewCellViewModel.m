//
//  ETNewFansListTableViewCellViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/6/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETNewFansListTableViewCellViewModel.h"

@implementation ETNewFansListTableViewCellViewModel

- (RACSubject *)attentionSubject {
    if (!_attentionSubject) {
        _attentionSubject = [RACSubject subject];
    }
    return _attentionSubject;
}

@end
