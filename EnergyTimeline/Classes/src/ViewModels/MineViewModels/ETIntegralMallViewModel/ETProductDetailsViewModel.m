//
//  ETProductDetailsViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/6/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETProductDetailsViewModel.h"
#import "Mine_Product_Get_Request.h"

@implementation ETProductDetailsViewModel

//- (void)et_initialize {
//    @weakify(self)
//    [self.refreshDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
//        @strongify(self)
//        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
//            NSMutableArray *array = [[NSMutableArray alloc] init];
//            for (NSDictionary *dic in responseObject[@"Data"]) {
////                ProductModel *model = [[ProductModel alloc] initWithDictionary:dic error:nil];
////                ETProductDetailsViewModel *viewModel = [[ETProductDetailsViewModel alloc] init];
////                viewModel.model = model;
////                [array addObject:viewModel];
//            }
////            self.dataArray = array;
//        }
//        [self.refreshEndSubject sendNext:nil];
//    }];
//    
//}

#pragma mark -- lazyLoad --

//- (RACSubject *)refreshEndSubject {
//    if (!_refreshEndSubject) {
//        _refreshEndSubject = [RACSubject subject];
//    }
//    return _refreshEndSubject;
//}

//- (RACCommand *)refreshDataCommand {
//    if (!_refreshDataCommand) {
//        @weakify(self)
//        _refreshDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//            @strongify(self)
//            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//                @strongify(self)
//                Mine_Product_Get_Request *productRequest = [[Mine_Product_Get_Request alloc] initWithProductID:[self.model.ProductID integerValue]];
//                [productRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
//                    [subscriber sendNext:request.responseObject];
//                    [subscriber sendCompleted];
//                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
//                    [MBProgressHUD showMessage:@"网络连接失败"];
//                    [subscriber sendCompleted];
//                }];
//                return nil;
//            }];
//        }];
//    }
//    return _refreshDataCommand;
//}

- (RACSubject *)exchangeSubject {
    if (!_exchangeSubject) {
        _exchangeSubject = [RACSubject subject];
    }
    return _exchangeSubject;
}

@end
