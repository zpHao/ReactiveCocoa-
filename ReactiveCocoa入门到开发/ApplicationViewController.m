//
//  ApplicationViewController.m
//  ReactiveCocoa入门到开发
//
//  Created by haozp on 2017/5/14.
//  Copyright © 2017年 haozp. All rights reserved.
//

#import "ApplicationViewController.h"
#import "RACSubjectView.h"
#import "ReactiveObjC.h"
#import "NSObject+RACKVOWrapper.h"

@interface ApplicationViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textF;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation ApplicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    //1、监听文本框
    //2、代替代理 RACSubject
    //3、代替 KVO
    //4、代替监听
    //5、代替通知
    

}

- (void)demo1{
    //1、监听文本框
    [_textF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@",x);
    }];
}

- (void)demo2{
    //2、代替代理 RACSubject
    
    //    [[_redView rac_signalForSelector:@selector(btnClick:)] subscribeNext:^(RACTuple * _Nullable x) {
    //        NSLog(@"%@",x);
    //    }];
}

- (void)demo3{
    //3、代替 KVO
    //导入#import "NSObject+RACKVOWrapper.h"
    
    [[_btn rac_valuesForKeyPath:@"frame" observer:nil] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

- (void)demo4{
    //4、代替监听
    //把我们的点击事件当作信号
    [[_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"%@",x);
    }];
}

- (void)demo5{
    //5、代替通知
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"%@",x);
    }];
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
