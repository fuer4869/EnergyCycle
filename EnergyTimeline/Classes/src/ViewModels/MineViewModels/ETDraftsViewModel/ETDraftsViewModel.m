//
//  ETDraftsViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/6/23.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETDraftsViewModel.h"
#import "ETDraftsTableViewCellViewModel.h"

@implementation ETDraftsViewModel

- (void)et_initialize {
    @weakify(self)
    
    [self.deleteSubject subscribeNext:^(ETDraftsTableViewCellViewModel *viewModel) {
        @strongify(self)
        DraftsModel *model = viewModel.model;
        /** 清除草稿的本地图片 */
        NSFileManager *manager = [NSFileManager defaultManager];
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePath = [file stringByAppendingPathComponent:model.imgLocalURL];
        filePath = [filePath stringByAppendingString:@".plist"];
        NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
        for (NSString *image in array) {
            [[SDImageCache sharedImageCache] removeImageForKey:image];
        }
        [manager removeItemAtPath:filePath error:nil];
        /** 删除草稿数据 */
        [model deleteObject];
        
        NSMutableArray *dataArr = [[NSMutableArray alloc] initWithArray:self.dataArray];
        [dataArr removeObject:viewModel];
        self.dataArray = dataArr;
        
        [self.refreshEndSubject sendNext:nil];
    }];
}

#pragma mark -- lazyLoad --

- (RACSubject *)refreshEndSubject {
    if (!_refreshEndSubject) {
        _refreshEndSubject = [RACSubject subject];
    }
    return _refreshEndSubject;
}

- (RACSubject *)deleteSubject {
    if (!_deleteSubject) {
        _deleteSubject = [RACSubject subject];
    }
    return _deleteSubject;
}

- (RACSubject *)resendSubejct {
    if (!_resendSubejct) {
        _resendSubejct = [RACSubject subject];
    }
    return _resendSubejct;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (DraftsModel *model in [DraftsModel findAll]) {
            ETDraftsTableViewCellViewModel *viewModel = [[ETDraftsTableViewCellViewModel alloc] init];
            viewModel.model = model;
            viewModel.resendSubject = self.resendSubejct;
            [array addObject:viewModel];
        }
        _dataArray = array;
    }
    return _dataArray;
}



@end
