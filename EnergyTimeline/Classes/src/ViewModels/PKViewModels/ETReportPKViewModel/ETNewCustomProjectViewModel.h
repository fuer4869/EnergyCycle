//
//  ETNewCustomProjectViewModel.h
//  能量圈
//
//  Created by 王斌 on 2018/2/1.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETViewModel.h"

typedef enum : NSUInteger {
    ETNewCustomProjectStatusName = 1,
    ETNewCustomProjectStatusUnit,
    ETNewCustomProjectStatusFinish,
} ETNewCustomProjectStatus;

@interface ETNewCustomProjectViewModel : ETViewModel

@property (nonatomic, strong) RACCommand *newProjectCommand; // 创建项目

@property (nonatomic, strong) RACSubject *setNameSubject; // 设置项目名

@property (nonatomic, strong) RACSubject *stautsChangeSubject; // 改变状态

@property (nonatomic, strong) RACSubject *removeSubject; // 关闭界面

@property (nonatomic, strong) RACSubject *completedSubject; // 完成

@property (nonatomic, assign) ETNewCustomProjectStatus customStatus; // 状态

@property (nonatomic, copy) NSString *projectName; // 项目名

@property (nonatomic, copy) NSString *unit; // 单位

@property (nonatomic, strong) NSArray *unitArray; // 单位列表

@end
