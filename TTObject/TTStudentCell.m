//
//  TTStudentCell.m
//  TTObject
//
//  Created by Wong on 17/2/24.
//  Copyright © 2017年 TTObject. All rights reserved.
//

#import "TTStudentCell.h"
#import "TTStudent.h"

@interface TTStudentCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *isAtLabel;

@end

@implementation TTStudentCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setStudent:(TTStudent *)student {
    _student = student;
    self.nameLabel.text = student.name;
    self.ageLabel.text = [NSString stringWithFormat:@"%d",student.age];
    self.numberLabel.text = [NSString stringWithFormat:@"%@",student.id_p];
    self.descLabel.text = student.description_p.length > 0 ? student.description_p : @"无";
    self.isAtLabel.text = student.isAtSchool ? @"是" : @"否";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
