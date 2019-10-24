//
//  ETOpinionViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/12/30.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "ETFirstEnterModel.h"

@interface ETOpinionViewModel : ETViewModel

@property (nonatomic, strong) RACSubject *refreshEndSubject;

@property (nonatomic, strong) RACCommand *refreshDataCommand;

@property (nonatomic, strong) RACCommand *nextPageCommand;

@property (nonatomic, strong) RACCommand *postDeleteCommand;

@property (nonatomic, strong) RACCommand *postLikeCommand;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) RACSubject *cellClickSubject;

@property (nonatomic, strong) RACSubject *homePageSubject;

@property (nonatomic, strong) RACSubject *postDeleteSubject;

@property (nonatomic, strong) RACSubject *postLikeSubject;

@property (nonatomic, strong) RACCommand *firstEnterDataCommand;

@property (nonatomic, strong) RACCommand *firstEnterUpdCommand;

@property (nonatomic, strong) RACSubject *firstEnterEndSubject;

@property (nonatomic, strong) ETFirstEnterModel *firstEnterModel;

@end
