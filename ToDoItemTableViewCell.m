//
//  ToDoItemTableViewCell.m
//  ToDoList
//
//  Created by Taylor Ledingham on 2014-10-22.
//  Copyright (c) 2014 Taylor Ledingham. All rights reserved.
//

#import "ToDoItemTableViewCell.h"

@implementation ToDoItemTableViewCell 

- (void)awakeFromNib {
    self.checkToCompleteButton.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (IBAction)checkmarkPressed:(UIButton *)sender {
    [self.delegate didPressCheckmarkButton:self];
}
@end
