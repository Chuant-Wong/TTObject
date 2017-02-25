//
//  TTStudent.h
//  TTObject
//
//  Created by Wong on 17/2/24.
//  Copyright © 2017年 TTObject. All rights reserved.
//

#import "TTObject.h"

@interface TTStudent : TTObject

@property (strong, nonatomic, nonnull) NSString *name;
@property (assign, nonatomic) int age;
@property (assign, nonatomic) BOOL isAtSchool;
@property (strong, nonatomic, nonnull) NSNumber *id_p;//学生学号
@property (strong, nonatomic, nullable) NSString *description_p;//学生描述

@end
