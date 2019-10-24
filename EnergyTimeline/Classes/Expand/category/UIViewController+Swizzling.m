//
//  UIViewController+Swizzling.m
//  EnergyTimeline
//
//  Created by vj on 2016/11/10.
//  Copyright © 2016年 Weijie Zhu. All rights reserved.
//

#import "UIViewController+Swizzling.h"
#import <objc/runtime.h>

@implementation UIViewController (Swizzling)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        Class class = [self class];

        Method method1 = class_getInstanceMethod(class, NSSelectorFromString(@"dealloc"));
        Method method2 = class_getInstanceMethod(class, @selector(et_dealloc));
        method_exchangeImplementations(method1, method2);
        
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(et_viewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        method_exchangeImplementations(originalMethod, swizzledMethod);

        // 如果 swizzling 的是类方法, 采用如下的方式:
        // Class class = object_getClass((id)self);
        // ...
        // Method originalMethod = class_getClassMethod(class, originalSelector);
        // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
        
        Method method_willDisappear_1 = class_getInstanceMethod(class, NSSelectorFromString(@"viewWillDisappear"));
        Method method_willDisappear_2 = class_getInstanceMethod(class, @selector(et_viewWillDisappear:));
        method_exchangeImplementations(method_willDisappear_1, method_willDisappear_2);
    });
}

- (void)et_dealloc
{
//    ETLog(@"%@ %@ 被释放了",self, NSStringFromClass([self class]));
    [self et_dealloc];
}

- (void)et_viewWillAppear:(BOOL)animated {
    
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    [self et_viewWillAppear:animated];
}

- (void)et_viewWillDisappear:(BOOL)animated {
    
    [MobClick endLogPageView:NSStringFromClass([self class])];
    [self et_viewWillDisappear:animated];
    
}


@end
