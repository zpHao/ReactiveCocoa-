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
    
    //RACSignal使用步骤：
    // 1.创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
    // 2.订阅信号,才会激活信号. - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    // 3.发送信号 - (void)sendNext:(id)value
    
    
    // RACSignal底层实现：
    // 1.创建信号，首先把didSubscribe保存到信号中，还不会触发。
    // 2.当信号被订阅，也就是调用signal的subscribeNext:nextBlock
    // 2.2 subscribeNext内部会创建订阅者subscriber，并且把nextBlock保存到subscriber中。
    // 2.1 subscribeNext内部会调用siganl的didSubscribe
    // 3.siganl的didSubscribe中调用[subscriber sendNext:@1];
    // 3.1 sendNext底层其实就是执行subscriber的nextBlock
    
    //创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {//subscriber 订阅者

        //发送信号
        [subscriber sendNext:@"hello RAC!"];
        [subscriber sendCompleted];

        //取消订阅
        // block调用时刻：当信号发送完成或者发送错误，就会自动执行这个block,取消订阅信号。
        // 执行完Block后，当前信号就不在被订阅了。
        // 如果不在发送数据，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号。
        //[subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            
            NSLog(@"取消订阅");
        }];
    }];
    
    //订阅信号
    [signal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    
    
    //订阅信号
    RACDisposable *disposable = [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    //手动取消订阅
    [disposable dispose];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
