//
//  TTObject.h
//  TTObject
//
//  Created by Wong on 17/2/24.
//  Copyright © 2017年 TTObject. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTObject : NSObject

+ (NSDictionary*)getObjectData:(id)obj;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (NSString *)objectMappingKey:(NSString *)sourceKey;

- (NSString *)dictionaryMappingKey:(NSString *)sourceKey;

- (Class)classWithObjectKey:(NSString *)objectKey;

- (NSDictionary *)toDictionary;

@end
