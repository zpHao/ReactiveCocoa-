//
//  FLAGES.h
//  ReactiveCocoa入门到开发
//
//  Created by haozp on 2017/5/14.
//  Copyright © 2017年 haozp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLAGES : NSObject

@property(copy, nonatomic) NSString * name;
@property(copy, nonatomic) NSString * icon;

+(instancetype)flageWithDict:(NSDictionary *)dict;

@end
