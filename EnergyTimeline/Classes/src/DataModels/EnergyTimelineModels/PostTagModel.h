//
//  PostTagModel.h
//  能量圈
//
//  Created by wb on 2017/9/29.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "JSONModel.h"

@interface PostTagModel : JSONModel

/** 权限 */
@property (nonatomic, strong) NSString<Optional> *Role;
/** 标签ID */
@property (nonatomic, strong) NSString<Optional> *TagID;
/** 标签名 */
@property (nonatomic, strong) NSString<Optional> *TagName;

@end
