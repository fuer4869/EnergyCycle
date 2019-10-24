//
//  Mine_Product_Exchange_Add_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/6/20.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 兑换商品 需登录 */
@interface Mine_Product_Exchange_Add_Request : ETRequest

- (id)initWithProductID:(NSInteger)productID Receiver:(NSString *)receiver ReceivePhone:(NSString *)receivePhone ReceiveAddress:(NSString *)receiveAddress;

@end
