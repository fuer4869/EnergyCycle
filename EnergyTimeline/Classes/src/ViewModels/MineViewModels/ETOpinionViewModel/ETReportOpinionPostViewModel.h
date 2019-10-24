//
//  ETReportOpinionPostViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/12/30.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"

@interface ETReportOpinionPostViewModel : ETViewModel

@property (nonatomic, strong) RACSubject *refreshEndSubject;

@property (nonatomic, strong) RACSubject *pickerSubject;

@property (nonatomic, strong) RACSubject *removePictureSubject;

@property (nonatomic, strong) RACSubject *dismissSubject;

@property (nonatomic, strong) RACCommand *uploadFileCommand;

@property (nonatomic, strong) RACCommand *reportCommand;

@property (nonatomic, strong) NSMutableArray *selectImgArray;

@property (nonatomic, strong) NSMutableArray *imageIDArray;

@property (nonatomic, strong) NSMutableArray *fileIDArray;

@property (nonatomic, strong) NSMutableString *fileIDString;

@property (nonatomic, copy) NSString *postContent;

@end
