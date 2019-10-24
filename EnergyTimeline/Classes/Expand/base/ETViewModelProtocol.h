//
//  ETViewModelProtocol.h
//  能量圈
//
//  Created by 王斌 on 2017/5/8.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ETHeaderRefresh_HasMoreData = 1,
    ETHeaderRefresh_HasNoMoreData,
    ETFooterRefresh_HasMoreData,
    ETFooterRefresh_HasNoMoreData,
    ETRefreshError,
    ETRefreshUI
} ETRefreshDataStatus;

@protocol ETViewModelProtocol <NSObject>

@optional

- (instancetype)initWithModel:(id)model;

- (void)et_initialize;

@end
