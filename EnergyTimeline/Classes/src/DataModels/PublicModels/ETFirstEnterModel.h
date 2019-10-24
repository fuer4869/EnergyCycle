//
//  ETFirstEnterModel.h
//  能量圈
//
//  Created by 王斌 on 2017/11/9.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "JSONModel.h"

@interface ETFirstEnterModel : JSONModel

/** 签到 */
@property (nonatomic, strong) NSString<Optional> *Is_CheckIn_Remind;
/** 训练 */
@property (nonatomic, strong) NSString<Optional> *Is_First_Train;
/** 修改头像 */
@property (nonatomic, strong) NSString<Optional> *Is_FirstEditProfile;

@property (nonatomic, strong) NSString<Optional> *Is_FirstEditProfile_Remind;
/** 一键汇总 */
@property (nonatomic, strong) NSString<Optional> *Is_FirstPool;
/** 一键汇总内部 */
@property (nonatomic, strong) NSString<Optional> *Is_FirstPool_Pic;
/** pk内部 */
@property (nonatomic, strong) NSString<Optional> *Is_FirstPK_Pic;
/** 动态 */
@property (nonatomic, strong) NSString<Optional> *Is_First_Post_Pic;
/** 吐槽 */
@property (nonatomic, strong) NSString<Optional> *Is_Suggest;
/** 新pk项目滚动列表 */
@property (nonatomic, strong) NSString<Optional> *Is_PK_Guide;

@property (nonatomic, strong) NSString<Optional> *UserID;

@end
