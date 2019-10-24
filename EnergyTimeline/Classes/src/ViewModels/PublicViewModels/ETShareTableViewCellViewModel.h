//
//  ETShareTableViewCellViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/5/25.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"

@interface ETShareTableViewCellViewModel : ETViewModel

@property (nonatomic, strong) RACSubject *timelineSubject;

@property (nonatomic, strong) RACSubject *wechatSubject;

@property (nonatomic, strong) RACSubject *weiboSubject;

@property (nonatomic, strong) RACSubject *qqSubject;

@property (nonatomic, strong) RACSubject *qzoneSubject;

@end
