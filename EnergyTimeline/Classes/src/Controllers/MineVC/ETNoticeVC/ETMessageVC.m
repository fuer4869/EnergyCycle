//
//  ETMessageVC.m
//  能量圈
//
//  Created by 王斌 on 2017/6/21.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETMessageVC.h"
#import "ETRefreshGifHeader.h"
#import "ETHomePageVC.h"

@interface ETMessageVC () <JSQMessagesComposerTextViewPasteDelegate, JSQMessagesCollectionViewDataSource>

@end

@implementation ETMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = ETMainBgColor;
    
    // 未知问题: 注册代理会闪退
//    self.inputToolbar.contentView.textView.pasteDelegate = self;
    
    
    self.inputToolbar.contentView.leftBarButtonItem = nil;
    self.inputToolbar.contentView.textView.backgroundColor = ETMinorBgColor;
    self.inputToolbar.contentView.textView.textColor = ETTextColor_Fourth;
    
    self.showLoadEarlierMessagesHeader = NO;
    
    WS(weakSelf)
    self.collectionView.mj_header = [ETRefreshGifHeader headerWithRefreshingBlock:^{
        [weakSelf.viewModel.nextPageCommand execute:nil];
    }];
    
    
    @weakify(self)
    
    [self.viewModel.refreshDataCommand execute:nil];
    
    [self.viewModel.refreshFirstEndSubject subscribeNext:^(id x) {
        [self.collectionView reloadData];
        [self scrollToBottomAnimated:NO];
    }];
    
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self)
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView reloadData];
    }];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"ETMessageVC"];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:ETBlackColor}];
    [self setupLeftNavBarWithimage:ETLeftArrow_Gray];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"ETMessageVC"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.title = self.viewModel.toUserNickName;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)setupLeftNavBarWithimage:(NSString *)imageName {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    /**
     *  设置frame只能控制按钮的大小
     */
    btn.frame= CGRectMake(0, 0, 30, 30);
    
    [btn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- lazyLoad --

- (ETMessageViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETMessageViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date {
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId senderDisplayName:senderDisplayName date:date text:text];
    [self.viewModel.addMessageCommand execute:text];
    [self.viewModel.messages addObject:message];
    [self finishSendingMessageAnimated:YES];
}

#pragma mark -- JSQMessages CollectionView DataSource --

- (NSString *)senderId {
    return User_ID;
}

- (NSString *)senderDisplayName {
    return User_NickName;
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel.messages objectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = [self.viewModel.messages objectAtIndex:indexPath.item];
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.viewModel.outgoingBubbleImageData;
    }
    
    return self.viewModel.incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *meesage = [self.viewModel.messages objectAtIndex:indexPath.row];
    return [self.viewModel.avatars objectForKey:meesage.senderId];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *prevMessage = [self.viewModel.messages objectAtIndex:indexPath.item - 1];
        JSQMessage *message = [self.viewModel.messages objectAtIndex:indexPath.item];
        NSInteger time = [message.date jk_minutesAfterDate:prevMessage.date];
        if (time > 5) {
            return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
        }
        
    }
    
    if (!indexPath.item) {
        JSQMessage *message = [self.viewModel.messages objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    return nil;
}

#pragma mark -- JSQMessagesCollectionViewDelegateFlowLayout --

- (void)collectionView:(UICollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *meesage = [self.viewModel.messages objectAtIndex:indexPath.row];
    ETHomePageVC *homePageVC = [[ETHomePageVC alloc] init];
    homePageVC.viewModel.userID = [meesage.senderId integerValue];
    [self.navigationController pushViewController:homePageVC animated:YES];
}

#pragma mark -- UICollectionView DataScource --

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel.messages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
//    JSQMessage *message = [self.viewModel.messages objectAtIndex:indexPath.item];
    
//    cell.textView.textColor = [UIColor blackColor];
//    cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
//                                          NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
////    cell.accessoryButton.hidden = ![self shouldShowAccessoryButtonForMessage:msg];
//    cell.cellTopLabel.hidden = NO;
    
    JSQMessage *message = [self.viewModel.messages objectAtIndex:indexPath.item];
    if ([message.senderId isEqualToString:self.senderId]) {
        cell.textView.textColor = ETBlackColor;
    } else {
        cell.textView.textColor = ETTextColor_First;
    }
    cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                          NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    cell.cellTopLabel.hidden = NO;

    return cell;
}

#pragma mark - Adjusting cell label heights --

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *prevMessage = [self.viewModel.messages objectAtIndex:indexPath.item - 1];
        JSQMessage *message = [self.viewModel.messages objectAtIndex:indexPath.item];
        NSInteger time = [message.date jk_minutesAfterDate:prevMessage.date];
        if (time > 5) {
            return kJSQMessagesCollectionViewCellLabelHeightDefault;
        }
        
    }
    
    if (!indexPath.item) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}

#pragma mark - Responding to collection view tap events --

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"更多历史消息");
    
}

#pragma mark - JSQMessagesComposerTextViewPasteDelegate methods --

- (BOOL)composerTextView:(JSQMessagesComposerTextView *)textView shouldPasteWithSender:(id)sender
{
    if ([UIPasteboard generalPasteboard].image) {
        // If there's an image in the pasteboard, construct a media item with that image and `send` it.
//        JSQPhotoMediaItem *item = [[JSQPhotoMediaItem alloc] initWithImage:[UIPasteboard generalPasteboard].image];
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:self.senderId
                                                 senderDisplayName:self.senderDisplayName
                                                              date:[NSDate date]
                                                             media:nil];
        [self.viewModel.messages addObject:message];
        [self finishSendingMessage];
        return NO;
    }
    return YES;
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
