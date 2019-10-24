//
//  User_CoverImg_Upd_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/6/16.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 修改个人中心背景图 需登录 */
@interface User_CoverImg_Upd_Request : ETRequest

- (id)initWithFileID:(NSInteger)fileID;

@end
