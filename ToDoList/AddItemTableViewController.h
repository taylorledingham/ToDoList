//
//  AddItemTableViewController.h
//  ToDoList
//
//  Created by Taylor Ledingham on 2014-10-24.
//  Copyright (c) 2014 Taylor Ledingham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "addItemToTableVCDelegate.h"
#import "ToDo.h"
#import "TLCoreDataStack.h"

@class ToDo;


@interface AddItemTableViewController : UITableViewController <UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate>


@property (weak, nonatomic) id <addItemToTableVCDelegate> delegate;
@property (strong, nonatomic) ToDo *entry;
@property (nonatomic) BOOL isEditing;
@property (nonatomic) BOOL displayOnly;

@property (weak, nonatomic) IBOutlet UILabel *priorityNumberLabel;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UISlider *prioritySlider;
@property (weak, nonatomic) IBOutlet UITextView *descTextView;
@property (weak, nonatomic) IBOutlet UIDatePicker *itemDatePicker;
@property (weak, nonatomic) IBOutlet UILabel *dateValueLabel;
- (IBAction)datePickerValueDidChange:(UIDatePicker *)sender;

- (IBAction)doneAddItem:(id)sender;

- (IBAction)priorityValueDidChange:(id)sender;
- (IBAction)setAsDefaultTask:(id)sender;

//- (IBAction)addNewItem:(id)sender;
//- (IBAction)doneAddItem:(id)sender;

@end
