//
//  TTStudents.m
//  TTObject
//
//  Created by Wong on 17/2/24.
//  Copyright © 2017年 TTObject. All rights reserved.
//

#import "TTStudents.h"
#import "TTStudent.h"

@implementation TTStudents

- (Class)classWithObjectKey:(NSString *)objectKey {
    if ([objectKey isEqualToString:@"student"] || [objectKey isEqualToString:@"students"]) {
        return [TTStudent class];
    }
    return [TTObject class];
}

@end
