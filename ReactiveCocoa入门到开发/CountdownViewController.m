//
//  CountdownViewController.m
//  ReactiveCocoa入门到开发
//
//  Created by haozp on 2017/5/14.
//  Copyright © 2017年 haozp. All rights reserved.
//

#import "CountdownViewController.h"
#import "ReactiveObjC.h"

@interface CountdownViewController ()
@property (nonatomic, assign) int time;
@property (nonatomic, strong) RACDisposable *disposable;
@end

@implementation CountdownViewController


- (IBAction)timeBtnClick:(UIButton *)sender {
    
    sender.enabled = NO;
    
    _time = 30;
    
    //如果没有把 RACDisposable 强引用，RAC会给它自动转弱，执行一次完了
    self.disposable = [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        //更新UI 设置按钮上的文字
        //1、time > 0  , 按钮上的时间倒计时
        //2、time <= 0 , 按钮上显示【重新发送】
        
        
        
        //感觉太low了 下面改进
//        if (_time > 0) {
//            sender.enabled = NO;
//            [sender setTitle:[NSString stringWithFormat:@"%ds",_time] forState:UIControlStateNormal];
//        }else{
//            sender.enabled = YES;
//            [sender setTitle:@"重新发送" forState:UIControlStateNormal];
//            
//            //关闭 timer (取消订阅)
//            [_disposable dispose];
//        }
        
        NSString *btnTitle = _time > 0 ? [NSString stringWithFormat:@"%ds",_time] : @"重新发送";
        [sender setTitle:btnTitle forState:UIControlStateNormal];
        
        
        
        if (_time > 0) {
            sender.enabled = NO;
        }else{
            sender.enabled = YES;
            //关闭 timer (手动取消订阅)
            [_disposable dispose];
        }
        
        _time --;
        
    }];
    
    
    //滑动scrollView，timer不受影响
    
}

-(void)dealloc{
    
    //只有当倒计时结束了，才会dealloc
    NSLog(@"我走了");
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
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
