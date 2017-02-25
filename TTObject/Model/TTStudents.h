//
//  TTStudents.h
//  TTObject
//
//  Created by Wong on 17/2/24.
//  Copyright © 2017年 TTObject. All rights reserved.
//


#import "TTObject.h"

@class TTStudent;

@interface TTStudents : TTObject

@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) TTStudent *student;
@property (strong, nonatomic) NSArray *students; //TTStudent对象集合

@end
