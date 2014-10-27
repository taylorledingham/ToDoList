//
//  AddItemViewController.h
//  ToDoList
//
//  Created by Taylor Ledingham on 2014-10-22.
//  Copyright (c) 2014 Taylor Ledingham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDo.h"
#import "addItemToTableVCDelegate.h"

@interface AddItemViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *itemName;
@property (weak, nonatomic) IBOutlet UITextView *itemDesc;
@property (weak, nonatomic) IBOutlet UISlider *prioritySlider;

@property (weak, nonatomic) id <addItemToTableVCDelegate> delegate;

- (IBAction)doneAddItem:(id)sender;

@end
