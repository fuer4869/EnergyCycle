//
//  PK_v4_Report_Add_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/12/30.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 汇报PK项目 可添加文字和图片 */
@interface PK_v4_Report_Add_Request : ETRequest

- (id)initWithReport_Items:(NSArray *)report_Items PostContent:(NSString *)postContent Is_Sync:(NSString *)is_Sync FileIDs:(NSString *)fileIDs;

@end
