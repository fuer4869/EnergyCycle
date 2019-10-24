//
//  UserModel.h
//  能量圈
//
//  Created by 王斌 on 2017/5/9.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "JSONModel.h"

@interface UserModel : JSONModel

#pragma mark -- 将要删除的 --
@property (nonatomic, strong) NSString<Ignore> *pinyin;
@property (strong,nonatomic) NSString<Optional> *isSelected;
@property (strong,nonatomic) NSString<Optional> *readyToDelete;


#pragma mark -- private --
/** 用户ID */
@property (nonatomic, strong) NSString<Optional> *UserID;
/** 用户姓名 */
@property (nonatomic, strong) NSString<Optional> *UserName;
/** 请求密文(256位) */
@property (nonatomic, strong) NSString<Optional> *Ticket;
/** 密码 */
@property (nonatomic, strong) NSString<Optional> *Pwd;
/** 用户权限:2.有权限,3.普通用户 */
@property (nonatomic, strong) NSString<Optional> *Role;
/** 登录名 */
@property (nonatomic, strong) NSString<Optional> *LoginName;
/** 登录方式 */
@property (nonatomic, strong) NSString<Optional> *LoginType;
/** 第三方登录ID */
@property (nonatomic, strong) NSString<Optional> *OpenID;
/** 积分 */
@property (nonatomic, strong) NSString<Optional> *Integral;
/** 邀请码 */
@property (nonatomic, strong) NSString<Optional> *InviteCode;
/** 上级推荐用户 */
@property (nonatomic, strong) NSString<Optional> *RegUserID;
/** 注册时间 */
@property (nonatomic, strong) NSString<Optional> *RegTime;


#pragma mark -- public -- 
/** 用户昵称 */
@property (nonatomic, strong) NSString<Optional> *NickName;
/** 出生日期 */
@property (nonatomic, strong) NSString<Optional> *Birthday;
/** 个人头像 */
@property (nonatomic, strong) NSString<Optional> *ProfilePicture;
/** 简介 */
@property (nonatomic, strong) NSString<Optional> *Brief;
/** 性别 0:未知 1:女 2:男 */
@property (nonatomic, strong) NSString<Optional> *Gender;
/** 背景图 */
@property (nonatomic, strong) NSString<Optional> *CoverImg;
/** 邮箱 */
@property (nonatomic, strong) NSString<Optional> *Email;
/** 登录时的验证码 */
@property (nonatomic, strong) NSString<Optional> *Code;
/** 是否关注 */
@property (nonatomic, strong) NSString<Optional> *Is_Attention;
/** 是否关注我 */
@property (nonatomic, strong) NSString<Optional> *Is_Attention_Me;
/** 关注数 */
@property (nonatomic, strong) NSString<Optional> *Attention;
/** 粉丝数 */
@property (nonatomic, strong) NSString<Optional> *Attention_Me;

@end
