//
//  Mine_Product_Exchange_Add_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/6/20.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "Mine_Product_Exchange_Add_Request.h"

/** 兑换商品 需登录 */
@implementation Mine_Product_Exchange_Add_Request {
    NSInteger _productID;
    NSString *_receiver;
    NSString *_receivePhone;
    NSString *_receiveAddress;
}

- (id)initWithProductID:(NSInteger)productID Receiver:(NSString *)receiver ReceivePhone:(NSString *)receivePhone ReceiveAddress:(NSString *)receiveAddress {
    if (self = [super init]) {
        _productID = productID;
        _receiver = receiver;
        _receivePhone = receivePhone;
        _receiveAddress = receiveAddress;
    }
    return self;
}

- (ETAPIManagerRequestType)requestMethod {
    return ETAPIManagerRequestTypePost;
}

- (NSString *)requestUrl {
    return @"ec/Product/Exchange_Add";
}

- (id)requestArgument {
    return @{@"ProductID":@(_productID),
             @"Receiver":_receiver,
             @"ReceivePhone":_receivePhone,
             @"ReceiveAddress":_receiveAddress};
}

@end
