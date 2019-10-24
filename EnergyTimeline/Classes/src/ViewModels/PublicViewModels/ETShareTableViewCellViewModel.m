//
//  ETShareTableViewCellViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/5/25.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETShareTableViewCellViewModel.h"

@implementation ETShareTableViewCellViewModel

- (RACSubject *)timelineSubject {
    if (!_timelineSubject) {
        _timelineSubject = [RACSubject subject];
    }
    return _timelineSubject;
}

- (RACSubject *)wechatSubject {
    if (!_wechatSubject) {
        _wechatSubject = [RACSubject subject];
    }
    return _wechatSubject;
}

- (RACSubject *)weiboSubject {
    if (!_weiboSubject) {
        _weiboSubject = [RACSubject subject];
    }
    return _weiboSubject;
}

- (RACSubject *)qqSubject {
    if (!_qqSubject) {
        _qqSubject = [RACSubject subject];
    }
    return _qqSubject;
}

- (RACSubject *)qzoneSubject {
    if (!_qzoneSubject) {
        _qzoneSubject = [RACSubject subject];
    }
    return _qzoneSubject;
}

@end
