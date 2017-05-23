//
//  LastViewController.m
//  ReactiveCocoa入门到开发
//
//  Created by haozp on 2017/5/15.
//  Copyright © 2017年 haozp. All rights reserved.
//

#import "LastViewController.h"
#import "ReactiveObjC.h"

#import "RACMulticastConnection.h"

#import "RACReturnSignal.h"

@interface LastViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textF;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation LastViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //bind 绑定
    //创建信号
    RACSubject *suject = [RACSubject subject];
    //绑定信号
    RACSignal *signal = [suject bind:^RACSignalBindBlock _Nonnull{
        
        //应用场景：字典转模型
        // value 通事 json 数据
        
        // value 他就是我们的原始信号发送內容
        // 只要原始信号发送了数据，就会调用这个 blcok
        
        
        //RACSignal * _Nullable (^RACSignalBindBlock)(ValueType _Nullable value, BOOL *stop);
        return ^RACSignal *(id _Nullable value, BOOL *stop){
            
//            return [RACSignal empty];
            return [RACReturnSignal return:value];
        };
    } ];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [suject sendNext:@"发送原始信号"];

}

//demo6的升级版  命令是否执行完 的判断
- (void)demo8{
    //创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        NSLog(@"%@",input);
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            [subscriber sendNext:@"命令执行完了之后产生的数据"];
            //发送完成
            [subscriber sendCompleted];
            return nil;
        }];
        
    }];
    
    [command.executing subscribeNext:^(NSNumber * _Nullable x) {
        NSLog(@"%@",x);//0 1
        if ([x boolValue]) {
            NSLog(@"正在执行");
        }else{
            NSLog(@"执行完成 或  没有开始");
        }
    }];
    
    //双重订阅
    //switchToLatest 看字面意思就是最后一个
    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    
    //执行命令
    [command execute:@"执行命令"];
}

//demo6的另一种写法 RACSubject
- (void)demo7{
    //创建多个信号
    RACSubject *signalOfSignal = [RACSubject subject];//信号中的信号
    RACSubject *signal1 = [RACSubject subject];
    RACSubject *signal2 = [RACSubject subject];
    RACSubject *signal3 = [RACSubject subject];
    
    // 订阅信号
    //    [signalOfSignal subscribeNext:^(id  _Nullable x) {
    //        [x subscribeNext:^(id  _Nullable x) {
    //            NSLog(@"==%@",x);
    //        }];
    //    }];
    [signalOfSignal.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //发送信号
    [signalOfSignal sendNext:signal1];
    [signalOfSignal sendNext:signal2];
    [signalOfSignal sendNext:signal3];
    
    [signal1 sendNext:@"1"];
    [signal2 sendNext:@"2"];
    [signal3 sendNext:@"3"];

}

//对demo5的进阶
- (void)demo6{
    //创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        NSLog(@"1-%@",input);
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            [subscriber sendNext:@"命令执行完了之后产生的数据"];
            return nil;
        }];
        
    }];
    
    
    //    //executionSignals:信号源
    //    //RACReplaySubject: 他可以做到 先發送 在訂閱
    //
    //    [command.executionSignals subscribeNext:^(id  _Nullable x) {
    //        NSLog(@"%@",x);///<RACDynamicSignal: 0x608000229640> name:
    //        //RACDynamicSignal:在最开始的时候就接触到了，点进去看下也是个信号，（看后缀就行）
    //        //所以我们在对X进行订阅
    //        [x subscribeNext:^(id  _Nullable x) {
    //            NSLog(@"2-%@",x);
    //        }];
    //    }];
    //双重订阅
    //上面的做法不觉得太麻烦了吗
    //switchToLatest 看字面意思就是最后一个
    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    
    //执行命令
    [command execute:@"执行命令"];
}
- (void)demo5{
    //创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        NSLog(@"1-%@",input);
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            [subscriber sendNext:@"命令执行完了之后产生的数据"];
            return nil;
        }];
        
    }];
    
    //执行命令
    RACSignal *signal = [command execute:@"执行命令"];
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"2-%@",x);
    }];
    
}

- (void)demo4{
    //RACTuplePack 把数组打包成元祖
    //RACTupleUnpack 解包
    RACTuple *tuple = RACTuplePack(@1,@2);
    NSLog(@"%@",tuple);
}

- (void)demo3{
    //RAC 对某个对象绑定属性
    [_textF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@",x);
    }];
   
    
    //赋值
    RAC(_label,text) = _textF.rac_textSignal;
    
    // 错误
    //    _label.text = _textF.text;
    
    //或者  监听某个对象的属性与 RAC(_label,text) = _textF.rac_textSignal; 混合使用
    [RACObserve(self.label, text) subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //例
    [RACObserve(self.label, frame) subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];

}
- (void)demo2{
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"发送请求");
        [subscriber sendNext:@"我拿到了数据"];
        return nil;
    }];
    
    //RACMulticastConnection 连接头
    RACMulticastConnection *connection = [signal publish];
    
    //订阅连接头
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"事件处理 1 %@",x);
        
    }];
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"事件处理 2 ");
    }];
    //连接
    [connection connect];

}

-(void)demo1{
    RACSignal * siganl1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"网络数据请求1");
        
        [subscriber sendNext:@"数据 1 来了"];
        
        return nil;
    }];
    
    RACSignal * siganl2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"网络数据请求2");
        
        [subscriber sendNext:@"数据 2 来了"];
        
        return nil;
    }];
    
    RACSignal * siganl3 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"网络数据请求3");
        
        [subscriber sendNext:@"数据 3 来了"];
        
        return nil;
    }];
    
    
    [self rac_liftSelector:@selector(upDateUIWithOneData:TwoData:ThreeData:) withSignalsFromArray:@[siganl1,siganl2,siganl3]];
    
    
    
}

-(void)upDateUIWithOneData:(NSString *) dataOne TwoData:(NSString *)dataTwo ThreeData:(NSString *)dataThree{
    NSLog(@"UI更新了   dataOn:%@  dataTwo:%@   dataThree:%@",dataOne,dataTwo,dataThree);
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
