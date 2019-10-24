//
//  ETSearchProjectViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/12/30.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"

@interface ETSearchProjectViewModel : ETViewModel

@property (nonatomic, strong) RACCommand *refreshDataCommand;

@property (nonatomic, strong) RACCommand *searchDataCommand;

@property (nonatomic, strong) RACSubject *refreshEndSubject;

@property (nonatomic, strong) RACSubject *searchEndSubject;

@property (nonatomic, strong) RACSubject *selectProjectSubject;

@property (nonatomic, strong) RACSubject *promiseSetProjectSubject;

@property (nonatomic, strong) RACSubject *newProejctSubject;

@property (nonatomic, strong) RACSubject *reportPKSubject;

@property (nonatomic, strong) NSMutableArray *selectArray;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) NSArray *typeImageArray;

@property (nonatomic, strong) NSArray *projectTypeArray;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSArray *searchDataArray;

@property (nonatomic, strong) NSString *searchKey;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign) BOOL isSearch;

@property (nonatomic, assign) BOOL isPromise;

@property (nonatomic, assign) BOOL showSubviews;

@end
