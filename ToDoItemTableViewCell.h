//
//  ToDoItemTableViewCell.h
//  ToDoList
//
//  Created by Taylor Ledingham on 2014-10-22.
//  Copyright (c) 2014 Taylor Ledingham. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ToDoItemTableViewCell;

@protocol ToDoItemTableViewCellDelegate <NSObject>

-(void) didPressCheckmarkButton:(ToDoItemTableViewCell *)cell;

@end

@interface ToDoItemTableViewCell : UITableViewCell

@property (weak, nonatomic) id <ToDoItemTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *itemTitle;
@property (weak, nonatomic) IBOutlet UILabel *itemDesc;
@property (weak, nonatomic) IBOutlet UILabel *itemPriority;
@property (weak, nonatomic) IBOutlet UIButton *checkToCompleteButton;
@property (weak, nonatomic) IBOutlet UILabel *completionDateLabel;

@property (strong, nonatomic) UISwipeGestureRecognizer *swipeGesture;


- (IBAction)checkmarkPressed:(UIButton *)sender;

@end
