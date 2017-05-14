//
//  FLAGES.m
//  ReactiveCocoa入门到开发
//
//  Created by haozp on 2017/5/14.
//  Copyright © 2017年 haozp. All rights reserved.
//

#import "FLAGES.h"

@implementation FLAGES

+(instancetype)flageWithDict:(NSDictionary *)dict{
    
    FLAGES * flages = [[FLAGES alloc]init];
    [flages setValuesForKeysWithDictionary:dict];
    return flages;
}
@end
