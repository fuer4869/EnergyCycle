//
//  ETShareView.h
//  能量圈
//
//  Created by 王斌 on 2017/5/3.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ETShareViewTypeFullScreen,
    ETShareViewTypeBottom
} ETShareViewType;

@protocol ETShareViewDelegate;

@interface ETShareView : UIView

@property (nonatomic, weak) id<ETShareViewDelegate> delegate;

+ (ETShareView *)shareViewWithBottomWithDelegate:(id)delegate;

+ (ETShareView *)shareViewWithFullScreenWithDelegate:(id)delegate;

@end

@protocol ETShareViewDelegate <NSObject>

@optional

/** 朋友圈分享 */
- (void)shareViewClickWechatTimelineBtn;
/** 微信好友分享 */
- (void)shareViewClickWechatSessionBtn;
/** 微博分享 */
- (void)shareViewClickSinaWeiboBtn;
/** QQ空间分享 */
- (void)shareViewClickQzoneBtn;
/** QQ分享 */
- (void)shareViewClickQQBtn;

/** 分享视图关闭回调 */
- (void)shareViewClose;

@end
