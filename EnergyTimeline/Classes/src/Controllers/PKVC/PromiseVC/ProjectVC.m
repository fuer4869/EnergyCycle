//
//  ProjectVC.m
//  EnergyCycles
//
//  Created by 王斌 on 2017/2/22.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ProjectVC.h"
#import "ProjectCollectionViewCell.h"
#import "PromiseCollectionFlowLayout.h"

//#import "PKSelectedModel.h"

#import "ETPKProjectModel.h"

#import "SetProjectVC.h"
#import "ETReportPKVC.h"

#import "PK_Project_List_Requset.h"

@interface ProjectVC ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation ProjectVC

static NSString * const reuseIdentifier = @"Cell";

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        self.dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)et_layoutNavigation {
    [self setupLeftNavBarWithimage:ETLeftArrow_Gray];
//    self.navigationController.navigationBar.layer.shadowColor = ETBlackColor.CGColor;
//    self.navigationController.navigationBar.layer.shadowOpacity = 0.1;
//    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 0);
}

- (void)et_willDisappear {
    [self resetNavigation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"项目";
//    self.view.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
    self.view.backgroundColor = ETProjectRelatedBGColor;
    
    [self setup];
    [self getData];
    
    // Do any additional setup after loading the view.
}

- (void)getData {
    
    PK_Project_List_Requset *projectListRequest = [[PK_Project_List_Requset alloc] init];
    [projectListRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
        if ([request.responseObject[@"Status"] integerValue] == 200) {
            for (NSDictionary *dic in request.responseObject[@"Data"]) {
                ETPKProjectModel *model = [[ETPKProjectModel alloc] initWithDictionary:dic error:nil];
                [self.dataArr addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }
    } failure:^(__kindof ETBaseRequest * _Nonnull request) {
        NSLog(@"%@", request.responseObject);
    }];
}

- (void)setup {
//    PromiseCollectionFlowLayout *layout = [[PromiseCollectionFlowLayout alloc] init];
//    layout.lineSpacing = 10;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    // 适配plus 多减1
    CGFloat itemWidth = (ETScreenW - 41) / 3;
    layout.itemSize = CGSizeMake(itemWidth, (itemWidth * 6) / 5);
    
    CGRect rect = self.view.bounds;
    rect.size.height -= kNavHeight;
    self.collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
//    self.collectionView.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
    self.collectionView.backgroundColor = ETProjectRelatedBGColor;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ProjectCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ProjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    ETPKProjectModel *model = self.dataArr[indexPath.row];
    
    [cell getDataWithModel:model];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ETPKProjectModel *model = self.dataArr[indexPath.row];
    
    if (self.type == 1) {
        [self.projectSubject sendNext:model];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        SetProjectVC *setVC = [[SetProjectVC alloc] init];
        setVC.model = model;
        [self.navigationController pushViewController:setVC animated:YES];
    }
    
//    ProjectCollectionViewCell *cell = (ProjectCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    if (cell) {
//        [UIView animateWithDuration:0.2
//                              delay:0
//             usingSpringWithDamping:0.8
//              initialSpringVelocity:2
//                            options:UIViewAnimationOptionLayoutSubviews
//                         animations:^{
////                             cell.transform = CGAffineTransformMakeScale(1.05, 1.05);
////                             cell.layer.shadowColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1].CGColor;
////                             cell.layer.shadowOpacity = 0.8;
////                             cell.layer.shadowRadius = 5;
////                             cell.layer.shadowOffset = CGSizeMake(0, 0);
////                             [collectionView bringSubviewToFront:cell];
//                             cell.projectImageView.transform = CGAffineTransformMakeScale(1.05, 1.05);
//                             cell.projectImageView.layer.shadowColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1].CGColor;
//                             cell.projectImageView.layer.shadowOpacity = 0.4;
//                             cell.projectImageView.layer.shadowRadius = 5;
//                             cell.projectImageView.layer.shadowOffset = CGSizeMake(0, 0);
//                             [collectionView bringSubviewToFront:cell];
//        } completion:^(BOOL finished) {
//            cell.projectImageView.transform = CGAffineTransformMakeScale(1, 1);
//            cell.projectImageView.layer.shadowColor = [UIColor clearColor].CGColor;
////            PKSelectedModel *model = self.dataArr[indexPath.row];
//            ETPKProjectModel *model = self.dataArr[indexPath.row];
//
//            if (self.type == 1) {
//                [self.projectSubject sendNext:model];
//                [self.navigationController popViewControllerAnimated:YES];
//            } else {
//                SetProjectVC *setVC = [[SetProjectVC alloc] init];
//                setVC.model = model;
//                [self.navigationController pushViewController:setVC animated:YES];
//            }
//        }];
//    }
}

- (RACSubject *)projectSubject {
    if (!_projectSubject) {
        _projectSubject = [[RACSubject alloc] init];
    }
    return _projectSubject;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
