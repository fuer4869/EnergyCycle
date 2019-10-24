//
//  ETLogPostListCollectionCellViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/11/30.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETLogPostListCollectionCellViewModel.h"

@implementation ETLogPostListCollectionCellViewModel

- (RACSubject *)attentionSubject {
    if (!_attentionSubject) {
        _attentionSubject = [RACSubject subject];
    }
    return _attentionSubject;
}

@end
