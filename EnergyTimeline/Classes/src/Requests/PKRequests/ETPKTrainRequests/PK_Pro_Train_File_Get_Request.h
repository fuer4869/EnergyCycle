//
//  PK_Pro_Train_File_Get_Request.h
//  能量圈
//
//  Created by 王斌 on 2018/4/2.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 项目训练音频下载(包括是否包含公用音频文件) */
@interface PK_Pro_Train_File_Get_Request : ETRequest

- (id)initWithProjectID:(NSInteger)projectID Is_HaveCommon:(NSString *)is_HaveCommon;

@end
