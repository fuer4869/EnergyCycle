//
//  PK_ProjectType_List_Request.h
//  能量圈
//
//  Created by 王斌 on 2018/1/5.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** PK项目列表(包含项目分类) */
@interface PK_ProjectType_List_Request : ETRequest

- (id)initWithSearchKey:(NSString *)searchKey;

- (id)initWithSearchKey:(NSString *)searchKey Sort:(NSString *)sort;

@end
