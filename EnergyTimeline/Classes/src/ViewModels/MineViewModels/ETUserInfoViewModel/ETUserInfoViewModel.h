//
//  ETUserInfoViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/10/31.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "UserModel.h"

@interface ETUserInfoViewModel : ETViewModel

@property (nonatomic, strong) RACCommand *userDataCommand;

@property (nonatomic, strong) RACCommand *uploadFileCommand;

@property (nonatomic, strong) RACCommand *uploadProfilePictureCommand;

@property (nonatomic, strong) RACCommand *editInfoCommand;

@property (nonatomic, strong) RACSubject *refreshUserModelSubject;

@property (nonatomic, strong) RACSubject *editEndSubject;

@property (nonatomic, strong) RACSubject *profilePictureSubject;

@property (nonatomic, strong) RACSubject *cellClickSubject;

@property (nonatomic, strong) UserModel *model;

@property (nonatomic, strong) UIImage *image;

@end
