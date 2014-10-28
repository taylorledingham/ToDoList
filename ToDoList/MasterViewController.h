//
//  MasterViewController.h
//  ToDoList
//
//  Created by Taylor Ledingham on 2014-10-22.
//  Copyright (c) 2014 Taylor Ledingham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDo.h"
#import "TLCoreDataStack.h"
#import "AddItemViewController.h"
#import "addItemToTableVCDelegate.h"
#import "ToDoItemTableViewCell.h"
#import "AddItemTableViewController.h"
#import "AppDelegate.h"

@interface MasterViewController : UITableViewController <addItemToTableVCDelegate, ToDoItemTableViewCellDelegate>

- (IBAction)saveItemsList:(id)sender;

-(void)addItemtoListItemArray:(ToDo *)newItem;

@end

