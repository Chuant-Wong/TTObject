//
//  TTStudent.m
//  TTObject
//
//  Created by Wong on 17/2/24.
//  Copyright © 2017年 TTObject. All rights reserved.
//

#import "TTStudent.h"

@implementation TTStudent

- (NSString *)objectMappingKey:(NSString *)sourceKey {
    if ([sourceKey isEqualToString:@"id_p"]) {
        return @"id";
    }
    if ([sourceKey isEqualToString:@"description_p"]) {
        return @"description";
    }
    return sourceKey;
}

- (NSString *)dictionaryMappingKey:(NSString *)sourceKey {
    if ([sourceKey isEqualToString:@"id"]) {
        return @"id_p";
    }
    if ([sourceKey isEqualToString:@"description"]) {
        return @"description_p";
    }
    return sourceKey;
}

@end
