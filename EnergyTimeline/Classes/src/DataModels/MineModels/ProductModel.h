//
//  ProductModel.h
//  能量圈
//
//  Created by 王斌 on 2017/6/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "JSONModel.h"

@interface ProductModel : JSONModel

/** 商品简介 */
@property (nonatomic, strong) NSString<Optional> *Brief;
/** 商品图片文件ID */
@property (nonatomic, strong) NSString<Optional> *FileID;
/** 商品图片路径 */
@property (nonatomic, strong) NSString<Optional> *FilePath;
/** 需要积分 */
@property (nonatomic, strong) NSString<Optional> *Integral;
/** 商品ID */
@property (nonatomic, strong) NSString<Optional> *ProductID;
/** 商品名称 */
@property (nonatomic, strong) NSString<Optional> *ProductName;
/** 参考价格 */
@property (nonatomic, strong) NSString<Optional> *RefPrice;

@end
