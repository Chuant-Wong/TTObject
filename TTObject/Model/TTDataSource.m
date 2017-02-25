//
//  TTDataSource.m
//  TTObject
//
//  Created by Wong on 17/2/24.
//  Copyright © 2017年 TTObject. All rights reserved.
//

#import "TTDataSource.h"

@implementation TTDataSource

+ (NSDictionary *)student {
    return @{@"name":@"张三",
             @"age":@15,
             @"id":@1,
             @"isAtSchool":@YES,
             @"description":@"品学兼优"
             };
}

+ (NSDictionary *)students {
    return @{
             @"message":@"获取成功",
             @"student":@{@"name":@"黄五", @"age":@14, @"id":@3, @"isAtSchool":@YES, @"description":@""},
             @"students":@[
              @{@"name":@"张三", @"age":@15, @"id":@1, @"isAtSchool":@YES, @"description":@"品学兼优"},
              @{@"name":@"李四", @"age":@16, @"id":@2, @"isAtSchool":@NO, @"description":@"吊尾车"},
              ]
            };
}


@end
