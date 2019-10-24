//
//  ETMessageVC.h
//  能量圈
//
//  Created by 王斌 on 2017/6/21.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "JSQMessagesViewController.h"
#import "ETMessageViewModel.h"

@interface ETMessageVC : JSQMessagesViewController

@property (nonatomic, strong) ETMessageViewModel *viewModel;

@end
