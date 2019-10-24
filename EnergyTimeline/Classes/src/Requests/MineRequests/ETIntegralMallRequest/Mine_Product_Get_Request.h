//
//  Mine_Product_Get_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/6/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 商品详情 需登录 */
@interface Mine_Product_Get_Request : ETRequest

- (id)initWithProductID:(NSInteger)productID;

@end
