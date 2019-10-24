//
//  PK_Likes_Add_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/5/22.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** PK点赞 需登录 */
@interface PK_Likes_Add_Request : ETRequest

- (id)initWithReportID:(NSInteger)reportID;

@end
