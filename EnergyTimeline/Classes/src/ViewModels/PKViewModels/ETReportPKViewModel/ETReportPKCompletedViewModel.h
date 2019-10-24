//
//  ETReportPKCompletedViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/10/24.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"

@interface ETReportPKCompletedViewModel : ETViewModel

@property (nonatomic, strong) RACCommand *refreshDataCommand;

@property (nonatomic, strong) RACSubject *refreshEndSubject;

@property (nonatomic, strong) RACSubject *completedSubject;

@property (nonatomic, strong) RACSubject *reportPostSubject;

@property (nonatomic, strong) NSArray *pkDataArray;

@property (nonatomic, assign) NSInteger userID;

@end
