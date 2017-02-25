//
//  TTObject.m
//  TTObject
//
//  Created by Wong on 17/2/24.
//  Copyright © 2017年 TTObject. All rights reserved.
//

#import "TTObject.h"
#import <objc/runtime.h>

@implementation TTObject


+ (NSDictionary*)getObjectData:(id)obj
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    for(int i = 0;i < propsCount; i++) {
        objc_property_t prop = props[i];
        id value = nil;
        @try {
            NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
            value = [self getObjectInternal:[obj valueForKey:propName]];
            if(value != nil) {
                [dic setObject:value forKey:propName];
            }
        }
        @catch (NSException *exception) {
            [self logError:exception];
        }
        
    }
    return dic;
}

+ (void)print:(id)obj
{
    NSLog(@"%@", [self getObjectData:obj]);
}


+ (NSData*)getJSON:(id)obj options:(NSJSONWritingOptions)options error:(NSError**)error
{
    return [NSJSONSerialization dataWithJSONObject:[self getObjectData:obj] options:options error:error];
}

+ (id)getObjectInternal:(id)obj
{
    if(!obj || [obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSNull class]]) {
        return obj;
    }
    
    if([obj isKindOfClass:[NSArray class]]) {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++) {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    
    if([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys) {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self getObjectData:obj];
}

+ (void)logError:(NSException*)exp
{
    NSLog(@"PrintObject Error: %@", exp);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (dictionary) {
            [self initializeWithDictionary:dictionary];
        }
    }
    return self;
}
- (void)initializeWithDictionary:(NSDictionary *)dictionary
{
    NSArray *allKeys = [dictionary allKeys];
    for (int keyIdx = 0; keyIdx < [allKeys count]; keyIdx++) {
        NSString *sKeyPath = [allKeys objectAtIndex:keyIdx];
        id value = [dictionary objectForKey:sKeyPath];
        if (value && ![value isKindOfClass:[NSNull class]]) {
            NSString *objectKey = [self dictionaryMappingKey:sKeyPath];
            //检查是否存在这个属性
            objc_property_t property_t = class_getProperty([self class], [objectKey UTF8String]);
            if (!property_t) {
                continue;
            }
            char *proType = property_copyAttributeValue(property_t, "T");
            NSString *strType = [NSString stringWithUTF8String:proType];
            if ([strType hasPrefix:@"@"]) {
                if ([value isKindOfClass:[NSDictionary class]]) {
                    Class subObjClass = [self classWithObjectKey:objectKey];
                    if ([strType rangeOfString:NSStringFromClass(subObjClass)].location != NSNotFound) {
                        if (subObjClass && [subObjClass isSubclassOfClass:[TTObject class]]) {
                            TTObject *obj = [[subObjClass alloc] initWithDictionary:(NSDictionary *)value];
                            [self setValue:obj forKey:objectKey];
                        }
                    }
                    
                } else if ([value isKindOfClass:[NSArray class]] ||
                           [value isKindOfClass:[NSSet class]]) {
                    NSArray *arrValue = nil;
                    id arrRst = nil;
                    if ([value isKindOfClass:[NSSet class]]) {
                        arrValue = [(NSSet *)value allObjects];
                        arrRst = [[NSMutableSet alloc] init];
                    } else {
                        arrValue = (NSArray *)value;
                        arrRst = [[NSMutableArray alloc] init];
                    }
                    
                    if ([strType rangeOfString:@"NSMutableArray"].location != NSNotFound ||
                        [strType rangeOfString:@"NSArray"].location != NSNotFound) {
                        arrRst = [[NSMutableArray alloc] init];
                    } else  if ([strType rangeOfString:@"NSMutableSet"].location != NSNotFound ||
                                [strType rangeOfString:@"NSSet"].location != NSNotFound) {
                        arrRst = [[NSMutableSet alloc] init];
                    } else {
                        continue;
                    }
                    //数组属性里必须时字典类型，忽略其他类型
                    Class arrSubObjectClass = [self classWithObjectKey:objectKey];
                    if ((arrSubObjectClass && [arrSubObjectClass isSubclassOfClass:[TTObject class]]) ||
                        (arrSubObjectClass && [arrSubObjectClass isSubclassOfClass:[NSString class]]) ||
                        (arrSubObjectClass && [arrSubObjectClass isSubclassOfClass:[NSNumber class]])) {
                        for (int objIdx = 0; objIdx < [arrValue count]; objIdx++) {
                            id value = [arrValue objectAtIndex:objIdx];
                            if ([value isKindOfClass:[NSDictionary class]]) {
                                TTObject *obj = [[arrSubObjectClass alloc] initWithDictionary:(NSDictionary *)value];
                                [arrRst addObject:obj];
                            } else {
                                [arrRst addObject:value];
                            }
                        }
                    }
                    [self setValue:arrRst forKey:objectKey];
                } else if ([value isKindOfClass:[NSString class]] ||
                           [value isKindOfClass:[NSNumber class]]) {
                    //属性只允许NSString, NSNumber类型
                    if ([strType rangeOfString:@"NSNumber"].location != NSNotFound) {
                        if ([value isKindOfClass:[NSString class]]) {
                            //将NSString全部转换为double类型存入NSNumber中，防止丢失
                            [self setValue:[NSNumber numberWithDouble:[(NSString *)value doubleValue]] forKey:objectKey];
                        } else {
                            [self setValue:value forKey:objectKey];
                        }
                    } else if ([strType rangeOfString:@"NSString"].location != NSNotFound) {
                        if ([value isKindOfClass:[NSNumber class]]) {
                            [self setValue:[NSString stringWithFormat:@"%@", value] forKey:objectKey];
                        } else {
                            [self setValue:value forKey:objectKey];
                        }
                    } else {
                        
                    }
                }
            } else {
                [self setValue:value forKey:objectKey];
            }
            free(proType);
        }
    }
}


- (NSDictionary *)toDictionary
{
    NSMutableDictionary *dicResult = [[NSMutableDictionary alloc] init];
    
    NSArray *propertyNames = [self initializePropertyNames];
    
    for (int proIdx = 0; proIdx < [propertyNames count]; proIdx++) {
        NSString *sName = [propertyNames objectAtIndex:proIdx];
        objc_property_t property_t = class_getProperty([self class], [sName UTF8String]);
        const char *proType = property_copyAttributeValue(property_t, "T");
        NSString *strType = [NSString stringWithUTF8String:proType];
        if ([strType hasPrefix:@"@"]) {
            id value = [self valueForKeyPath:sName];
            if (value && ![value isKindOfClass:[NSNull class]]) {
                NSString *dicKey = [self objectMappingKey:sName];
                if ([value isKindOfClass:[TTObject class]]) {
                    //如果是TTObject类型，那么值应该是个属性
                    TTObject *obj = (TTObject *)value;
                    [dicResult setObject:[obj toDictionary] forKey:dicKey];
                } else if ([value isKindOfClass:[NSArray class]]) {
                    NSArray *arrValue = (NSArray *)value;
                    NSMutableArray *arrRst = [[NSMutableArray alloc] init];
                    //数组里只能允许TTObject子类
                    for (int objIdx = 0; objIdx < [arrValue count]; objIdx++) {
                        id value = [arrValue objectAtIndex:objIdx];
                        if ([value isKindOfClass:[TTObject class]]) {
                            [arrRst addObject:[value toDictionary]];
                        } else if ([value isKindOfClass:[NSString class]] ||
                                   [value isKindOfClass:[NSNumber class]]) {
                            [arrRst addObject:value];
                        }
                    }
                    [dicResult setObject:arrRst forKey:dicKey];
                } else if ([value isKindOfClass:[NSSet class]]) {
                    NSArray *arrValue = [(NSSet *)value allObjects];
                    NSMutableSet *setRst = [[NSMutableSet alloc] init];
                    //集合里只能允许TTObject子类
                    for (int objIdx = 0; objIdx < [arrValue count]; objIdx++) {
                        id value = [arrValue objectAtIndex:objIdx];
                        if ([value isKindOfClass:[TTObject class]]) {
                            [setRst addObject:[value toDictionary]];
                        } else if ([value isKindOfClass:[NSString class]] ||
                                   [value isKindOfClass:[NSNumber class]]) {
                            [setRst addObject:value];
                        }
                    }
                    [dicResult setObject:setRst forKey:dicKey];
                } else if ([value isKindOfClass:[NSString class]] ||
                           [value isKindOfClass:[NSNumber class]]) {
                    [dicResult setObject:value forKey:dicKey];
                }
            }
        } else {
            id value = [self valueForKeyPath:sName];
            [dicResult setValue:value forKey:sName];
        }
    }
    return dicResult;
}

- (NSArray *)initializePropertyNames
{
    return [self initializePropertyNamesWithClass:[self class]];
}

- (NSArray *)initializePropertyNamesWithClass:(Class)objClass
{
    if (objClass && [objClass isSubclassOfClass:[TTObject class]]) {
        NSMutableArray *result = [[NSMutableArray alloc] init];
        
        unsigned int propertyCount = 0;
        //只能找到本对象的类属性，需要递归到TTObject类的属性
        objc_property_t *properties = class_copyPropertyList(objClass, &propertyCount);
        for (int i = 0; i < propertyCount; i++) {
            const char *propertyName = property_getName(properties[i]);
            NSString *sName = [NSString stringWithUTF8String:propertyName];
            [result addObject:sName];
        }
        free(properties);
        NSArray *subPropertyNames = [self initializePropertyNamesWithClass:[objClass superclass]];
        if (subPropertyNames) {
            [result addObjectsFromArray:subPropertyNames];
        }
        return result;
    } else {
        return nil;
    }
}


- (Class)classWithObjectKey:(NSString *)objectKey
{
    return NULL;
}
- (NSString *)dictionaryMappingKey:(NSString *)sourceKey
{
    return sourceKey;
}

- (NSString *)objectMappingKey:(NSString *)sourceKey
{
    return sourceKey;
}


@end
