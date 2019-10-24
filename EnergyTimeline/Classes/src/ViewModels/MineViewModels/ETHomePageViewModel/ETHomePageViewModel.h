//
//  ETHomePageViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/6/11.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "UserModel.h"

typedef enum : NSUInteger {
    ETListTypeLog = 1,
    ETListTypeDailyPK,
    ETListTypePKRecord,
    ETListTypePromise
} ETListType;

@interface ETHomePageViewModel : ETViewModel

/** 结束刷新 */
@property (nonatomic, strong) RACSubject *refreshLogEndSubject;

@property (nonatomic, strong) RACSubject *refreshPromiseEndSubject;

@property (nonatomic, strong) RACSubject *refreshPKEndSubject;

@property (nonatomic, strong) RACSubject *refreshPKRecordEndSubject;

@property (nonatomic, strong) RACSubject *refreshUserModelSubject;

/** 滑动代理 */

@property (nonatomic, strong) RACSubject *scrollViewSubject;

@property (nonatomic, strong) RACSubject *leaveFromTopSubject;

/** 普通帖子与公众承诺 */
@property (nonatomic, strong) RACCommand *refreshLogDataCommand;

@property (nonatomic, strong) RACCommand *nextLogPageCommand;

@property (nonatomic, strong) NSArray *logDataArray;

/** 公众承诺 */
@property (nonatomic, strong) RACCommand *refreshPromiseDataCommand;

@property (nonatomic, strong) RACCommand *nextPromisePageCommand;

@property (nonatomic, strong) NSArray *promiseDataArray;

/** 今日PK */
@property (nonatomic, strong) RACCommand *refreshPKDataCommand;

//@property (nonatomic, strong) RACCommand *nextPKPageCommand;

@property (nonatomic, strong) NSArray *pkDataArray;

/** PK记录 */
@property (nonatomic, strong) RACCommand *refreshPKRecordCommand;

//@property (nonatomic, strong) RACCommand *nextPKRecordCommand;

@property (nonatomic, strong) NSArray *pkRecordDataArray;

@property (nonatomic, strong) RACSubject *pkRecordCellClickSubject;

/** 帖子相关 */

@property (nonatomic, strong) RACCommand *pkReportCommand;

@property (nonatomic, strong) RACCommand *postDeleteCommand;

@property (nonatomic, strong) RACCommand *postLikeCommand;

@property (nonatomic, strong) RACSubject *cellClickSubject;

@property (nonatomic, strong) RACSubject *postDeleteSubject;

@property (nonatomic, strong) RACSubject *postLikeSubject;

/** 用户信息相关 */

@property (nonatomic, strong) RACSubject *attentionListSubject;

@property (nonatomic, strong) RACSubject *fansListSubject;

@property (nonatomic, strong) RACSubject *messageSubject;

@property (nonatomic, strong) RACSubject *attentionSubject;

@property (nonatomic, strong) RACSubject *setCoverImgSubject;

@property (nonatomic, strong) RACSubject *setProfilePictureSubject;

@property (nonatomic, strong) RACCommand *uploadFileCommand;

@property (nonatomic, strong) RACCommand *uploadCoverImgCommand;

@property (nonatomic, strong) RACCommand *uploadProfilePictureCommand;

@property (nonatomic, strong) RACCommand *userDataCommand;

@property (nonatomic, strong) RACCommand *attentionCommand;

@property (nonatomic, strong) UserModel *model;

@property (nonatomic, assign) NSInteger userID;

@property (nonatomic, assign) ETListType listType;

@property (nonatomic, assign) BOOL isOtherUser;

- (id)initWithUserID:(NSInteger)userID;

@end
