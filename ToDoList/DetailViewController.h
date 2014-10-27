//
//  DetailViewController.h
//  ToDoList
//
//  Created by Taylor Ledingham on 2014-10-22.
//  Copyright (c) 2014 Taylor Ledingham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDo.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) ToDo * detailItem;

@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *itemDescTextView;
@property (weak, nonatomic) IBOutlet UILabel *itemPriorityLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemIsCompleteLabel;


@end

