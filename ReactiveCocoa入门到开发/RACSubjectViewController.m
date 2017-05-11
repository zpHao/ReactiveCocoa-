//
//  RACSubjectViewController.m
//  ReactiveCocoa入门到开发
//
//  Created by haozp on 2017/5/9.
//  Copyright © 2017年 haozp. All rights reserved.
//

#import "RACSubjectViewController.h"
#import "ReactiveObjC.h"
#import "RACSubjectView.h"

@interface RACSubjectViewController ()
@property (weak, nonatomic) IBOutlet RACSubjectView *sujectView;

@end

@implementation RACSubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //一、RACSubject
    [self racSubject];
    
    
    //二、RACSubject运用
    //我们已经有信号创建的方法了，为什么我们还要用Subject？ 因为它可以代替KVO！可以代替通知！也可以代替代理！
    
    //订阅信号
//    //1.简单的传个参数
//    [self.sujectView.btnClickSignal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@",x);
//    }];
    //2.把sujectView上的按钮传过来
    [self.sujectView.btnClickSignal subscribeNext:^(UIButton* x) {
        self.title = x.titleLabel.text;
    }];
    
}

- (void)racSubject{
    //1、创建信号
    RACSubject *subject = [RACSubject subject];
    
    //2、订阅信号
    //订阅的方法跟之前一样使用 subscribeNext 来订阅我们的信号，不管你来不来，不管你什么时候来～ 反正我就是订阅了，来了之后拿了数据就开始使用。
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //3、发送信号
    //之前我们发送数据是在创建的时候发送的，但是此时此刻我们创建就是只是创建，现在我们要单独调用一个发送数据的方法 sendNext
    [subject sendNext:@"RACSubject我来了！"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
