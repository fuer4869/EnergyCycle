//
//  File_FileSource_Get_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/11/1.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "File_FileSource_Get_Request.h"

/** 根据文件ID获取文件信息 */
@implementation File_FileSource_Get_Request {
    NSInteger _fileID;
}

- (id)initWithFileID:(NSInteger)fileID {
    if (self = [super init]) {
        _fileID = fileID;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/File/FileSource_Get";
}

- (id)requestArgument {
    return @{@"FileID":@(_fileID)};
}

@end
