//
//  SetViewController.m
//  ReactiveCocoa入门到开发
//
//  Created by haozp on 2017/5/14.
//  Copyright © 2017年 haozp. All rights reserved.
//

#import "SetViewController.h"
#import "ReactiveObjC.h"
#import "FLAGES.h"

@interface SetViewController ()

@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1、元祖
    // swift 中的元祖，他可以装进任何类型的数据
    // OC 中的数组只能存放对象
    // RAC 中的元祖，封装了一层 OC 的数组
    
    RACTuple *tuple = [RACTuple tupleWithObjects:@[@"1",@1],@[@"2",@2], nil];
    NSLog(@"%@",tuple[1]);
    
    RACTuple * tuple1 = [RACTuple tupleWithObjectsFromArray:@[@"apple",@"google",@123]];
    NSString * str = tuple1[0];
    NSLog(@"%@",str);
    
    
    
    //2、处理数组，遍历
    NSArray * array1 = @[@"apple",@"google",@123];
    
    [array1.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
//    RACSequence * squence = array.rac_sequence; // 把数组转成集合类
//    RACSignal * signal = squence.signal; // 把集合累当作信号(创建信号)
//    [signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@",x);
//    }];
    
    //3、处理字典
    NSDictionary * dict = @{@"str0":@"hello",@"str1":@"thank"};
    [dict.rac_sequence.signal subscribeNext:^(RACTwoTuple * x) {
        NSLog(@"%@",x);
        //可以熟悉下RAC的各种宏
        RACTupleUnpack(NSString * key, NSString * value) = x;
        NSLog(@"key 是 %@, value 是 %@", key, value);
    }];
    
    
    //3、应用
//    RACSequence 他可以代替我们的数组，也可以代替字典
//    常用来解析 json 数据，最常使用的场合是 『字典转模型』
    
    NSString * filePath = [[NSBundle mainBundle]pathForResource:@"flags.plist" ofType:nil];
    NSArray * array2 = [NSArray arrayWithContentsOfFile:filePath];
    
    //一般思维用法
//    NSMutableArray * muArray = [NSMutableArray array];
//    [array.rac_sequence.signal subscribeNext:^(NSDictionary * x) {
//        
//        //進行字典轉模型
//        FLAGES * flages = [FLAGES flageWithDict:x];
//        [muArray addObject:flages];
//    }];

    
    //升级版超爽用法
    //value 集合里面所有的元素
    
    NSArray * modelArray = [[array2.rac_sequence map:^id _Nullable(NSDictionary * value) {
        
        return [FLAGES flageWithDict:value];
    }]array];
    
    NSLog(@"%@",modelArray);
    
//    我们自己定义了一个可变数组，然后再给他每次接收信号的时候把它转成对象放到术组里面去。
    
//    其实我们上下两边做的是一样的事情，此时此刻我们用了map 唯一的不同点是，他拿到了之后需要我们把这个对象给返回出去。因为它会自动帮我们把对象存到一个集合里面去。这个集合可以自动帮我们转成数组，因为它就是一个模型数组。
    

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
