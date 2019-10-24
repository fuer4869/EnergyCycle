//
//  PK_Project_Add_Request.h
//  能量圈
//
//  Created by 王斌 on 2018/2/2.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETRequest.h"

@interface PK_Project_Add_Request : ETRequest

- (id)initWithProjectName:(NSString *)projectName projectUnit:(NSString *)projectUnit;

@end
