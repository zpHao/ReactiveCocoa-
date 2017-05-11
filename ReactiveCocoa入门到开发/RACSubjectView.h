//
//  RACSubjectView.h
//  ReactiveCocoa入门到开发
//
//  Created by haozp on 2017/5/9.
//  Copyright © 2017年 haozp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"

@interface RACSubjectView : UIView
@property (nonatomic, strong) RACSubject *btnClickSignal;

@end
