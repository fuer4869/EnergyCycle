//
//  PK_My_Report_Ranking_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/12/29.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "PK_My_Report_Ranking_Request.h"

/** 我的项目排名情况 */
@implementation PK_My_Report_Ranking_Request {
    NSInteger _projectID;
}

- (id)initWithProjectID:(NSInteger)projectID {
    if (self = [super init]) {
        _projectID = projectID;
    }
    return self;
}

- (ETAPIManagerRequestType)requestMethod {
    return ETAPIManagerRequestTypeGet;
}

- (NSString *)requestUrl {
    return @"ec/pk/My_Report_Ranking";
}

- (id)requestArgument {
    return @{@"ProjectID":@(_projectID)};
}

@end
