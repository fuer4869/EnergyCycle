//
//  ETShareModel.h
//  能量圈
//
//  Created by 王斌 on 2017/5/27.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "JSONModel.h"

@interface ETShareModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *title;

@property (nonatomic, strong) NSString<Optional> *content;

@property (nonatomic, strong) NSString<Optional> *shareUrl;

@property (nonatomic, strong) NSArray<Optional> *imageArray;

@end
