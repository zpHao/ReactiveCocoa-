//
//  RACSignalViewController.m
//  ReactiveCocoa入门到开发
//
//  Created by haozp on 2017/5/9.
//  Copyright © 2017年 haozp. All rights reserved.
//

#import "RACSignalViewController.h"
#import "ReactiveObjC.h"

@interface RACSignalViewController ()

@end

@implementation RACSignalViewController


//RAC信号三部曲
//1、创建信号
//2、订阅信号
//3、发送信号

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"创建信号");
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {//subscriber 订阅者

        NSLog(@"发送信号");
        [subscriber sendNext:@"hello RAC!"];
        
        
        return [RACDisposable disposableWithBlock:^{
            //取消信号 1:信号发送完 2:信号发送失败
            NSLog(@"取消订阅");
        }];
    }];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"订阅信号");
        NSLog(@"%@",x);
    }];
    
    
    
//    //手动取消订阅
//    RACDisposable *disposable = [signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@",x);
//    }];
//    //手动取消订阅
//    [disposable dispose];

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
