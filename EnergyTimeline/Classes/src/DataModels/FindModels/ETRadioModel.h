//
//  ETRadioModel.h
//  能量圈
//
//  Created by 王斌 on 2017/6/6.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "JSONModel.h"

@interface ETRadioModel : JSONModel

/** 背景图片文件ID */
@property (nonatomic, strong) NSString<Optional> *FileID_Bg;
/** icon图片文件ID */
@property (nonatomic, strong) NSString<Optional> *FileID_Icon;
/** 电台是否禁用 */
@property (nonatomic, strong) NSString<Optional> *Is_Disabled;
/** 电台ID */
@property (nonatomic, strong) NSString<Optional> *RadioID;
/** 电台名称 */
@property (nonatomic, strong) NSString<Optional> *RadioName;
/** 电台地址 */
@property (nonatomic, strong) NSString<Optional> *RadioUrl;
/** 电台背景图片地址 */
@property (nonatomic, strong) NSString<Optional> *Radio_Bg;
/** 电台模糊背景图片地址 */
@property (nonatomic, strong) NSString<Optional> *Radio_Bg_Dim;
/** 电台icon图片地址 */
@property (nonatomic, strong) NSString<Optional> *Radio_Icon;

@end
