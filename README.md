# TTObject
## 能做什么 <br>
TTObject 是一套字典和模型之间互相转换的超轻量级框架 </br>
JSON --> Model </br>
Model --> JSON </br>  
# Manually【手动导入】 </br>
1.将TTObject文件夹中的所有源代码拽入项目中 </br>
2.导入主头文件：#import "TTObject.h"
## Examples【示例】
### JSON -> Model【最简单的字典转模型】

@interface TTStudent : TTObject
@property (strong, nonatomic, nonnull) NSString *name;
@property (assign, nonatomic) int age;
@property (assign, nonatomic) BOOL isAtSchool;
@property (strong, nonatomic, nonnull) NSNumber *id_p;
@property (strong, nonatomic, nullable) NSString *description_p;

@end


+ (NSDictionary *)student {
    return @{@"name":@"张三",
             @"age":@15,
             @"id":@1,
             @"isAtSchool":@YES,
             @"description":@"品学兼优"
             };
}

// JSON -> TTStudent
    TTStudent *student = [[TTStudent alloc] initWithDictionary:student];

### Model -> JSON【最简单的模型转字典】
    TTStudent *student = [[TTStudent alloc] init];
    student.name = @"张三";
    student.age = 20;
    student.description_p = @"描述";
    NSDictionary *dic = [student toDictionary];
    
  ## 用法要点 <br>
  1.TTStudent要继承TTObject  </br>
  2.TTStudent中含有关键字的重命名</br>
  调用方法: </br>
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



  
  
    
    
