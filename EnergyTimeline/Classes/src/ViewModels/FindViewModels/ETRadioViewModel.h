//
//  ETRadioViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/6/6.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "ETRadioModel.h"
#import "ETRadioLocalModel.h"

@interface ETRadioViewModel : ETViewModel

@property (nonatomic, strong) RACSubject *refreshEndSubject;

@property (nonatomic, strong) RACSubject *dismissSubject;

@property (nonatomic, strong) RACCommand *radioDataCommand;

@property (nonatomic, strong) NSArray *radioArray;

@property (nonatomic, strong) ETRadioModel *radioModel;

@property (nonatomic, strong) ETRadioLocalModel *localModel;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, strong) RACSubject *replacePlaySubject;

@property (nonatomic, strong) RACSubject *replaceEndSubject;

@property (nonatomic, strong) RACSubject *radioVCSubject;

@property (nonatomic, strong) RACSubject *radioPlayVCSubject;

@property (nonatomic, strong) RACSubject *radioDurationTimeVCSubject;

@end
