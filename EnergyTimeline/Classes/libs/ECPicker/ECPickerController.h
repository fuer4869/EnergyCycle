//
//  ECPickerController.h
//  EnergyCycles
//
//  Created by 王斌 on 16/9/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECPhotoListVC.h"
#import "ECAlbumListVC.h"

@interface ECPickerController : UINavigationController

@property (nonatomic, assign) NSInteger imageMaxCount;

@property (nonatomic, strong) NSMutableArray *imageIDArr;

@property (nonatomic, weak) id<ECPickerControllerDelegate> pickerDelegate;

@end
