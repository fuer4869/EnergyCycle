//
//  File_FileSource_Get_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/11/1.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 根据文件ID获取文件信息 */
@interface File_FileSource_Get_Request : ETRequest

- (id)initWithFileID:(NSInteger)fileID;

@end
