//
//  AdvancedViewController.m
//  ReactiveCocoa入门到开发
//
//  Created by haozp on 2017/5/23.
//  Copyright © 2017年 haozp. All rights reserved.
//

#import "AdvancedViewController.h"
#import "ReactiveObjC.h"
#import "RACReturnSignal.h"

@interface AdvancedViewController ()

@end

@implementation AdvancedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    
    
    

    
}
 //RAC过滤
- (void)demo9{
    //distinctUntilChange 过滤到重复的信号
    RACSubject * subject1 = [RACSubject subject];
    
    
    [[subject1 distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [subject1 sendNext:@"data1"];
    [subject1 sendNext:@"data1"];
    [subject1 sendNext:@"data12"];
    [subject1 sendNext:@"data12"];
}
 //RAC过滤
- (void)demo8{
    //take的高级用法takeUntil直到
    RACSubject * subject1 = [RACSubject subject];
    RACSubject * subject2 = [RACSubject subject];
    [[subject1 takeUntil:subject2] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
        //打印：data1，data2，data3
    }];
    
    [subject1 sendNext:@"data1"];
    [subject1 sendNext:@"data2"];
    [subject1 sendNext:@"data3"];
    [subject2 sendNext:@"STOP"];
    [subject1 sendNext:@"data4"];
}
//RAC忽略
- (void)demo7{
    //take 指定订阅，忽略掉其他的
    RACSubject * subject  = [RACSubject subject];
    
    //take : 指定订阅（从前到后）前几个
    [[subject take:3] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //takeLast: (从后到前) 后几个
    [[subject takeLast:2] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    
    [subject sendNext:@"data1"];
    [subject sendNext:@"data2"];
    [subject sendNext:@"data3"];
    [subject sendNext:@"data4"];
    [subject sendCompleted];
}
//RAC忽略
- (void)demo6{
    // ignore忽略某个／某些 信号
    
    RACSubject * subject = [RACSubject subject];
    //    忽略一些值
    //    [[subject ignore:@"data1"] subscribeNext:^(id  _Nullable x) {
    //        NSLog(@"%@",x);
    //    }];
    //    忽略所有值
    //    [[subject ignoreValues] subscribeNext:^(id  _Nullable x) {
    //        NSLog(@"%@",x);
    //    }];
    //    忽略某些值
    [[[subject ignore:@"data1"] ignore:@"data2"] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [subject sendNext:@"data1"];
    [subject sendNext:@"data2"];
    [subject sendNext:@"data3"];
    
}
- (void)demo5{
    //then 忽略
    RACSignal * signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSLog(@"发送请求 1");
        
        [subscriber sendNext:@"data1"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal * signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSLog(@"发送请求 2");
        [subscriber sendNext:@"data2"];
        
        return nil;
    }];
    //当signal1 发送完毕后  忽略  data1 发送 signal2
    [[signal1 then:^RACSignal * _Nonnull{
        return signal2;
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];

}
//RAC信号组合
- (void)demo4{
    //zipWith: 多个信号组合，当他组合的两个信号，同时发送了信息类，他会回传一个元祖
    RACSubject * subject1 = [RACSubject subject];
    RACSubject * subject2 = [RACSubject subject];
    
    //压缩信号
    RACSignal * zipSignal = [subject1 zipWith:subject2];
    [zipSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    
    [subject1 sendNext:@"data1"];
    [subject2 sendNext:@"data2"];
    
    [subject1 sendNext:@"data11"];
    [subject2 sendNext:@"data22"];
    
    [subject1 sendNext:@"data111"];
    [subject2 sendNext:@"data222"];
    

}

//RAC信号组合
- (void)demo3{
    //RAC信号组合
    //1、concat 按照顺序组合的信号
    RACSignal * signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSLog(@"发送请求 1");
        
        [subscriber sendNext:@"data1"];
        [subscriber sendCompleted]; //发送完毕
        return nil;
    }];
    
    RACSignal * signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSLog(@"发送请求 2");
        [subscriber sendNext:@"data2"];
        [subscriber sendCompleted]; //发送完毕
        return nil;
    }];
    
    RACSignal * signal3 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSLog(@"发送请求 3");
        [subscriber sendNext:@"data3"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    
    [[RACSignal concat:@[signal3,signal2,signal1]] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];

}

//flattenMap, map 映射
- (void)demo2{
    //创建多个信号
    RACSubject *signalOfSignal = [RACSubject subject];//信号中的信号
    RACSubject *signal1 = [RACSubject subject];
    
    
    [[signalOfSignal flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        return value;
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //    [signalOfSignal.switchToLatest subscribeNext:^(id  _Nullable x) {
    //        NSLog(@"%@",x);
    //    }];
    
    //发送信号
    [signalOfSignal sendNext:signal1];
    
    
    [signal1 sendNext:@"data"];
}
//flattenMap, map 映射
- (void)demo1{
    //创建信号
    RACSubject *subject = [RACSubject subject];
    //    //订阅信号
    //    [subject subscribeNext:^(id  _Nullable x) {
    //        NSLog(@"%@",x);
    //    }];
    //    //发送信号
    //    [subject sendNext:@"en"];
    
    
    //flattenMap, map 映射
//    //返回一个信号源
//    [[subject flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
//        
//        NSString *valueStr = [NSString stringWithFormat:@"被处理过的 %@ 数据",value];
//        return [RACReturnSignal return:valueStr];
//    }] subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@",x);
//    }];
    
    [[subject map:^id _Nullable(id  _Nullable value) {
        NSString *valueStr = [NSString stringWithFormat:@"被处理过的 %@ 数据",value];
        return valueStr;
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //发送信号
    [subject sendNext:@"123"];
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
