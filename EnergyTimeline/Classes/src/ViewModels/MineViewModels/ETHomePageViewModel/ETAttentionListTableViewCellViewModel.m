//
//  ETAttentionListTableViewCellViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/6/23.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETAttentionListTableViewCellViewModel.h"

@implementation ETAttentionListTableViewCellViewModel

- (RACSubject *)attentionSubject {
    if (!_attentionSubject) {
        _attentionSubject = [RACSubject subject];
    }
    return _attentionSubject;
}

@end
