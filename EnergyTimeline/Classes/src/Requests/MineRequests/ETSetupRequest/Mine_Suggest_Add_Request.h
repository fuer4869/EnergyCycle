//
//  Mine_Suggest_Add_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/6/29.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 新增建议 需登录 */
@interface Mine_Suggest_Add_Request : ETRequest

- (id)initWithSuggestContent:(NSString *)suggestContent;

@end
