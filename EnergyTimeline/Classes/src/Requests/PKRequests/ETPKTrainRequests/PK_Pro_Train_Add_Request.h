//
//  PK_Pro_Train_Add_Request.h
//  能量圈
//
//  Created by 王斌 on 2018/3/30.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 新增训练目标 */
@interface PK_Pro_Train_Add_Request : ETRequest

/**
 projectID: 项目ID
 targetNum: 目标数量
 soundType: 音源(1.海哥 2.熊威 3.尌安)
 bgmFileName: bgm(激烈, 舒缓, 节奏)
 */
- (id)initWithProjectID:(NSInteger)projectID TargetNum:(NSInteger)targetNum SoundType:(NSInteger)soundType BGMFileName:(NSString *)bgmFileName;

@end
