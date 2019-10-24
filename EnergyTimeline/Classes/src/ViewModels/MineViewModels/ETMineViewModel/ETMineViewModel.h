//
//  ETMineViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/6/10.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "UserModel.h"
#import "ETFirstEnterModel.h"

@interface ETMineViewModel : ETViewModel

@property (nonatomic, strong) RACSubject *mineHomePageSubject;

@property (nonatomic, strong) RACSubject *changeProfilePictureSubject;

@property (nonatomic, strong) RACSubject *profilePictureSubject;

@property (nonatomic, strong) RACSubject *setupSubject;

@property (nonatomic, strong) RACSubject *noticeSubject;

@property (nonatomic, strong) RACSubject *myInfoSubject;

@property (nonatomic, strong) RACSubject *draftsSubject;

@property (nonatomic, strong) RACSubject *integralRecordSubject;

@property (nonatomic, strong) RACSubject *cellClickSubject;

@property (nonatomic, strong) RACSubject *firstEnterEndSubject;

@property (nonatomic, strong) RACCommand *userDataCommand;

@property (nonatomic, strong) RACCommand *myLikeCommand;

@property (nonatomic, strong) RACCommand *noticeDataCommand;

@property (nonatomic, strong) RACCommand *uploadFileCommand;

@property (nonatomic, strong) RACCommand *uploadProfilePictureCommand;

@property (nonatomic, strong) RACSubject *refreshUserModelSubject;

@property (nonatomic, strong) RACCommand *firstEnterDataCommand;

@property (nonatomic, strong) RACCommand *firstEnterUpdCommand;

@property (nonatomic, strong) UserModel *model;

@property (nonatomic, strong) ETFirstEnterModel *firstEnterModel;

@property (nonatomic, strong) NSString *LikesNum;

@property (nonatomic, strong) NSString *LikesRanking;

@property (nonatomic, assign) NSInteger noticeNotReadCount;

@end
