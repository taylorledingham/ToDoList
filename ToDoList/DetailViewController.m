//
//  DetailViewController.m
//  ToDoList
//
//  Created by Taylor Ledingham on 2014-10-22.
//  Copyright (c) 2014 Taylor Ledingham. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

//- (void)setDetailItem:(ToDo *)newDetailItem {
//    if (_detailItem != newDetailItem) {
//        _detailItem = newDetailItem;
//            
//        // Update the view.
//        [self configureView];
//    }
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.itemNameLabel.text = self.detailItem.itemTitle;
        self.itemDescTextView.text = self.detailItem.itemDesc;
        self.itemPriorityLabel.text = [NSString stringWithFormat:@"Priority: %.0f", self.detailItem.priority];
        self.itemIsCompleteLabel.text = [NSString stringWithFormat:@"Completed: %@", [self getStringFromBool:self.detailItem.isCompleted]] ;
    }else{
        NSLog(@"!self.detailItem!!");
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)getStringFromBool:(BOOL)boolToConvert {
    
    if(boolToConvert == YES){
        return @"yes";
    }
    else {
        return @"no";
    }
    
}

@end
