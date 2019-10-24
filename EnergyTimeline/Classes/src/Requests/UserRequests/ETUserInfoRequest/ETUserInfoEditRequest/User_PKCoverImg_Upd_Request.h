//
//  User_PKCoverImg_Upd_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/5/21.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 修改PK背景图 需登录 */
@interface User_PKCoverImg_Upd_Request : ETRequest

- (id)initWithFileID:(NSInteger)fileID;

@end
