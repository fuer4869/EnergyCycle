//
//  ETFindViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/6/1.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "ETRadioViewModel.h"

@interface ETFindViewModel : ETViewModel

@property (nonatomic, strong) RACSubject *refreshEndSubject;

@property (nonatomic, strong) RACCommand *refreshDataCommand;

@property (nonatomic, strong) RACCommand *nextPageCommand;

@property (nonatomic, strong) RACCommand *bannerCommand;

@property (nonatomic, strong) RACCommand *postLikeCommand;

@property (nonatomic, strong) RACCommand *postDeleteCommand;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSArray *topBannerArray;

@property (nonatomic, strong) NSArray *bottomBannerArray;

@property (nonatomic, strong) RACSubject *searchSubject;

//@property (nonatomic, strong) RACSubject *bannerCellClickSubjet;

@property (nonatomic, strong) RACSubject *topBannerCellClickSubjet;

@property (nonatomic, strong) RACSubject *bottomBannerCellClickSubject;

@property (nonatomic, strong) RACSubject *cellClickSubject;

@property (nonatomic, strong) RACSubject *homePageSubject;

@property (nonatomic, strong) RACSubject *postLikeSubject;

@property (nonatomic, strong) RACSubject *postDeleteSubject;

@property (nonatomic, strong) ETRadioViewModel *radioViewModel;

@end
