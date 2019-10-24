//
//  ETReportPKPoolViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/11/24.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "ETFirstEnterModel.h"

@interface ETReportPKPoolViewModel : ETViewModel

@property (nonatomic, strong) RACSubject *refreshEndSubject;

@property (nonatomic, strong) RACSubject *refreshImageDataEndSubject;

@property (nonatomic, strong) RACSubject *pickerSubject;

@property (nonatomic, strong) RACSubject *removePictureSubject;

@property (nonatomic, strong) RACSubject *dismissSubject;

@property (nonatomic, strong) RACSubject *firstEnterEndSubject;

@property (nonatomic, strong) RACCommand *firstEnterDataCommand;

@property (nonatomic, strong) RACCommand *firstEnterUpdCommand;

@property (nonatomic, strong) RACCommand *refreshDataCommand;

@property (nonatomic, strong) RACCommand *refreshImgDataCommand;

@property (nonatomic, strong) RACCommand *uploadFileCommand;

@property (nonatomic, strong) RACCommand *reportCommand;

@property (nonatomic, strong) RACCommand *rankingNumCommand;

@property (nonatomic, strong) NSArray *pkDataArray;

@property (nonatomic, strong) NSMutableArray *selectImgPathArray;

@property (nonatomic, strong) NSMutableArray *selectImgArray;

@property (nonatomic, strong) NSMutableArray *imageIDArray;

@property (nonatomic, strong) NSMutableArray *todaySelectImgArray;

@property (nonatomic, strong) NSMutableArray *todayImageIDArray;

@property (nonatomic, strong) NSMutableArray *fileIDArray;

@property (nonatomic, strong) NSMutableString *fileIDString;

@property (nonatomic, strong) NSString *postContent;

@property (nonatomic, assign) NSInteger userID;

@property (nonatomic, copy) NSString *shareTitle;

@property (nonatomic, strong) ETFirstEnterModel *firstEnterModel;

@end
