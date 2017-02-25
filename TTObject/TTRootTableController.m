//
//  TTRootTableController.m
//  TTObject
//
//  Created by Wong on 17/2/24.
//  Copyright © 2017年 TTObject. All rights reserved.
//

#import "TTRootTableController.h"
#import "TTStudentController.h"
#import "TTDataSource.h"
#import "TTStudent.h"
#import "TTStudents.h"

@interface TTRootTableController ()

@end


@implementation TTRootTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    TTStudent *student = [[TTStudent alloc] initWithDictionary:[TTDataSource student]];
    NSLog(@"student = %@", [student toDictionary]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *cell = (UITableViewCell *)sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if ([segue.destinationViewController isKindOfClass:[TTStudentController class]]) {
        TTStudentController *studentVC = segue.destinationViewController;
        studentVC.students = [self students:indexPath];
    }
}

- (NSArray *)students:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        TTStudent *student = [[TTStudent alloc] initWithDictionary:[TTDataSource student]];
        return @[student];
    } else {
        TTStudents *student = [[TTStudents alloc] initWithDictionary:[TTDataSource students]];
         return student.students;
    }
}

@end
