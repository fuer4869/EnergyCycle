//
//  Mine_Product_Get_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/6/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "Mine_Product_Get_Request.h"

/** 商品详情 需登录 */
@implementation Mine_Product_Get_Request {
    NSInteger _productID;
}

- (id)initWithProductID:(NSInteger)productID {
    if (self = [super init]) {
        _productID = productID;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/Product/Product_Get";
}

- (id)requestArgument {
    return @{@"ProductID":@(_productID)};
}

@end
