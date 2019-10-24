//
//  ETBannerModel.h
//  能量圈
//
//  Created by 王斌 on 2017/6/2.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "JSONModel.h"

@interface ETBannerModel : JSONModel

/** banner的内容(链接) */
@property (nonatomic, strong) NSString<Optional> *BannerContent;
/** banner的ID */
@property (nonatomic, strong) NSString<Optional> *BannerID;
/** banner的名字 */
@property (nonatomic, strong) NSString<Optional> *BannerName;
/** banner的文件ID */
@property (nonatomic, strong) NSString<Optional> *FileID;
/** banner的图片 */
@property (nonatomic, strong) NSString<Optional> *FilePath;
/** 是否禁用 */
@property (nonatomic, strong) NSString<Optional> *Is_Disabled;
/** banner的显示区域类型 */
@property (nonatomic, strong) NSString<Optional> *ViewArea;

@end
