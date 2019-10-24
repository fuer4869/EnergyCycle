//
//  User_FirstEnter_Upd_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/11/9.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

typedef enum : NSUInteger {
    ETFirstEnterTypeCheckIn = 1,
    ETFirstEnterTypeFirstEditProfile,
    ETFirstEnterTypeFirstPK_Pic,
    ETFirstEnterTypePool
} ETFirstEnterType;

/** 用户所有功能提醒_更新 */
@interface User_FirstEnter_Upd_Request : ETRequest

- (id)initWithStr:(NSString *)str;

@end
