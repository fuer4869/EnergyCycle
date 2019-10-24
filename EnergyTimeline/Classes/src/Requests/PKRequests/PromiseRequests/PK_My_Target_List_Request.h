//
//  PK_My_Target_List_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/5/23.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

@interface PK_My_Target_List_Request : ETRequest

- (id)initWithType:(NSInteger)type PageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize;

@end
