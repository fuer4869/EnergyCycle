//
//  PK_My_TargetDetails_List_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/5/23.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

@interface PK_My_TargetDetails_List_Request : ETRequest

- (id)initWithStartDate:(NSString *)startDate EndDate:(NSString *)endDate;

@end
