# TTObject
## 能做什么 <br>
TTObject 是一套字典和模型之间互相转换的超轻量级框架 </br>
JSON --> Model </br>
Model --> JSON </br>  
##【手动导入】 </br>
1.将TTObject文件夹中的所有源代码拽入项目中 </br>
2.导入主头文件：#import "TTObject.h"
## Examples【示例】
### JSON -> Model【最简单的字典转模型】

@interface TTStudent : TTObject <br>
@property (strong, nonatomic, nonnull) NSString *name; </br>
@property (assign, nonatomic) int age; </br>
@property (assign, nonatomic) BOOL isAtSchool; </br>
@property (strong, nonatomic, nonnull) NSNumber *id_p; </br>
@property (strong, nonatomic, nullable) NSString *description_p;</br>
@end 

+ (NSDictionary *)student {  <br>
    return @{@"name":@"张三",  </br>
            @"age":@15,     </br>
            @"id":@1,      </br>
            @"isAtSchool":@YES,   </br>
             @"description":@"品学兼优" </br>  
              }; </br>
} </br>

// JSON -> TTStudent </br>
    TTStudent *student = [[TTStudent alloc] initWithDictionary:student];

### Model -> JSON【最简单的模型转字典】
    TTStudent *student = [[TTStudent alloc] init];
    student.name = @"张三";
    student.age = 20;
    student.description_p = @"描述";
    NSDictionary *dic = [student toDictionary];

### JSON -> Model【模型中有个数组属性，数组里面又要装着其他模型】
@interface TTStudents : TTObject<br>
@property (strong, nonatomic) NSString *message;</br>
@property (strong, nonatomic) TTStudent *student;</br>
@property (strong, nonatomic) NSArray *students; //TTStudent对象集合</br>
@end</br>

+ (NSDictionary *)students {</br>
    return @{</br>
             @"message":@"获取成功",</br>
             @"student":@{@"name":@"黄五", @"age":@14, @"id":@3, @"isAtSchool":@YES, @"description":@""}</br>,
             @"students":@[</br>
              @{@"name":@"张三", @"age":@15, @"id":@1, @"isAtSchool":@YES, @"description":@"品学兼优"},</br>
              @{@"name":@"李四", @"age":@16, @"id":@2, @"isAtSchool":@NO, @"description":@"吊尾车"},</br>
              ]</br>
            };</br>
}</br>

// JSON -> TTStudents</br>
      TTStudents *students = [[TTStudents alloc] initWithDictionary:[TTDataSource students]];
## 用法要点 <br>
  1.TTStudent要继承TTObject  </br>
  2.TTStudent中含有关键字的重命名</br>
要实现方法: </br>
- (NSString *)objectMappingKey:(NSString *)sourceKey {  </br>
    if ([sourceKey isEqualToString:@"id_p"]) {  </br>
        return @"id";  </br>
    }  </br>
    if ([sourceKey isEqualToString:@"description_p"]) { </br>
        return @"description"; </br>
    } </br>
    return sourceKey; </br>
 }</br>
    
- (NSString *)dictionaryMappingKey:(NSString *)sourceKey {</br>
    if ([sourceKey isEqualToString:@"id"]) {</br>
        return @"id_p";</br>
    }</br>
    if ([sourceKey isEqualToString:@"description"]) {</br>
        return @"description_p";</br>
    }</br>
    return sourceKey;</br>
}</br>

3.模型嵌套模型</br>
 要实现的方法</br>
- (Class)classWithObjectKey:(NSString *)objectKey {</br>
   if ([objectKey isEqualToString:@"student"] || [objectKey isEqualToString:@"students"]) {</br>
       return [TTStudent class];</br>
   }</br>
   return [TTObject class];</br>
}</br>

  
    
    
