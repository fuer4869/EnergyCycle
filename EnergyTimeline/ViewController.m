//
//  ViewController.m
//  EnergyTimeline
//
//  Created by vj on 2016/11/10.
//  Copyright © 2016年 Weijie Zhu. All rights reserved.
//

#import "ViewController.h"
#import "LoginRequest.h"
//#import <ChameleonFramework/Chameleon.h>
#import "ETPopView.h"
#import "ETLoginVC.h"
#import "PhoneCode_Get_Request.h"
#import "ETShareView.h"

@interface ViewController ()<ETPopViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
//    self.navigationController
    
    NSLog(@"abbbbbbb");
    NSLog(@"REQUEST_URL%@",REQUEST_URL);

    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    label.text = @"1111";
    [self.view addSubview:label];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    button1.frame = CGRectMake(self.view.center.x, self.view.center.y, 200, 40);
    button1.backgroundColor = [UIColor blueColor];
    [button1 addTarget:self action:@selector(click1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    button2.frame = CGRectMake(self.view.center.x, button1.jk_bottom, 200, 40);
    button2.backgroundColor = [UIColor redColor];
    [button2 addTarget:self action:@selector(click2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeSystem];
    button3.frame = CGRectMake(self.view.center.x, button2.jk_bottom, 200, 40);
    button3.backgroundColor = [UIColor orangeColor];
    [button3 addTarget:self action:@selector(click3) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeSystem];
    button4.frame = CGRectMake(self.view.center.x, button3.jk_bottom, 200, 40);
    button4.backgroundColor = [UIColor yellowColor];
    [button4 addTarget:self action:@selector(click4) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button4];
    
    UIButton *time = [[UIButton alloc] init];
    [time setTitle:@"啦啦啦" forState:UIControlStateNormal];
    [time setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [time addTarget:self action:@selector(click5:) forControlEvents:UIControlEventTouchUpInside];
    time.frame = CGRectMake(self.view.center.x, button4.jk_bottom, 200, 40);
    [self.view addSubview:time];
    
    UIButton *button5 = [UIButton buttonWithType:UIButtonTypeSystem];
    button5.frame = CGRectMake(self.view.center.x, time.jk_bottom, 200, 40);
    button5.backgroundColor = [UIColor blackColor];
    [button5 addTarget:self action:@selector(click6) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button5];

    
    LoginRequest *request = [[LoginRequest alloc] initWithPhoneNum:@"15021615315" password:@"Wb5131282"];
    [request startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
        
    } failure:^(__kindof ETBaseRequest * _Nonnull request) {
        
    }];
    
    // Do any additional setup after loading the view.
}

- (void)click1 {
    NSString *string = @"123";
    [string jk_md5String];
    
    [ETPopView popViewWithTip:@"撒都费脑我拜佛我安倍佛我把DOI拜佛安倍覅偶阿布佛我不打扫覅保四部分代表发表if吧"];
}

- (void)click2 {
    [ETPopView popViewWithTitle:@"lalalala" Tip:@"撒都费脑我拜佛我安倍佛我把DOI拜佛安倍覅偶阿布佛我不打扫覅保四部分代表发表if吧"];
}

- (void)click3 {
    [ETPopView popViewWithDelegate:self Title:@"allalaalal" Tip:@"撒都费脑我拜佛我安倍佛我把DOI拜佛安倍覅偶阿布佛我不打扫覅保四部分代表发表if吧" SureBtnTitle:@"确定"];
}

- (void)click4 {
    [ETPopView popViewWithDelegate:self Title:@"sdafhoaid" Tip:@"这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容" SureBtnTitle:@"确定" CancelBtnTitle:@"取消"];
}

- (void)click5:(UIButton *)time {
    [time jk_startTime:10 title:@"啦啦啦" waitTittle:@"秒"];
    PhoneCode_Get_Request *request = [[PhoneCode_Get_Request alloc] initWithPhoneNo:@"15021615315" type:2 VerificationCode:User_HashCode];
    [request startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
//        [input sendNext:request];
    } failure:^(__kindof ETBaseRequest * _Nonnull request) {
//        [input sendNext:request];
    }];
//    [time setTitle:[NSString jk_UUIDTimestamp] forState:UIControlStateNormal];
}

- (void)click6 {
    [ETShareView shareViewWithBottomWithDelegate:self];
}

- (void)popViewClickSureBtn {
    NSLog(@"sure");
    ETLoginVC *loginVC = [[ETLoginVC alloc] init];
    [self presentViewController:loginVC animated:YES completion:nil];
}

- (void)popViewClickCancelBtn {
    NSLog(@"cancel");
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
