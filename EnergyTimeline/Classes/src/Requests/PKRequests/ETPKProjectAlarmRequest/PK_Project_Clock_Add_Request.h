//
//  PK_Project_Clock_Add_Request.h
//  能量圈
//
//  Created by 王斌 on 2018/1/25.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETRequest.h"

@interface PK_Project_Clock_Add_Request : ETRequest

- (id)initWithClockID:(NSInteger)clockID ProjectID:(NSInteger)projectID Is_Enabled:(NSString *)is_Enabled RemindTime:(NSString *)remindTime RemindDate:(NSString *)remindDate;

@end
