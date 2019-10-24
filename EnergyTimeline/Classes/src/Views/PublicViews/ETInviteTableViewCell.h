//
//  ETInviteTableViewCell.h
//  能量圈
//
//  Created by 王斌 on 2017/6/5.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ETShareTimeline = 0,
    ETShareWechat,
    ETShareWeibo,
    ETShareQQ,
    ETShareQzone,
    ETShareAddressBook
} ETShareType;

@interface ETInviteTableViewCell : UITableViewCell

@property (nonatomic, assign) ETShareType shareType;

@end
