//
//  Mine_Notice_MenTion_List_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/6/26.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 通知列表-帖子提到的人 需登录 */
@interface Mine_Notice_MenTion_List_Request : ETRequest

- (id)initWithPageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize;

@end
