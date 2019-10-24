//
//  ETDailyPKPageViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/5/16.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"

@interface ETDailyPKPageViewModel : ETViewModel

@property (nonatomic, strong) RACCommand *projectListCommand;

@property (nonatomic, strong) RACCommand *uploadFileCommand;

@property (nonatomic, strong) RACCommand *uploadPKCoverImgCommand;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) NSArray *coverImgArray;

@property (nonatomic, strong) RACSubject *pageViewCellClickSubject;

@property (nonatomic, strong) RACSubject *removePageViewSubject;

@property (nonatomic, strong) RACSubject *popSubject;

@property (nonatomic, strong) RACSubject *submitSubject;

@property (nonatomic, strong) RACSubject *setupSubject;

@property (nonatomic, strong) RACSubject *refreshSubject;

@property (nonatomic, assign) NSInteger currentIndex;

@end
