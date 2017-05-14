//
//  RACSubjectView.m
//  ReactiveCocoa入门到开发
//
//  Created by haozp on 2017/5/9.
//  Copyright © 2017年 haozp. All rights reserved.
//

#import "RACSubjectView.h"

@implementation RACSubjectView

//这个信号要在什么时候创建？
//应该是要在你拿了数据要发送的时候创建的〜
//所以用到懒加载

- (RACSubject *)btnClickSignal{
    if (!_btnClickSignal) {
        //懒加载创建信号
        _btnClickSignal = [RACSubject subject];
    }
    return _btnClickSignal;
}
- (IBAction)BtnClick:(id)sender{
    //发送信号
//    [self.btnClickSignal sendNext:@"按钮点击了"];//1
    [self.btnClickSignal sendNext:sender];//2
    
    
    //代替代理 RACSubject
    NSLog(@"代替代理 RACSubject");
}


@end
