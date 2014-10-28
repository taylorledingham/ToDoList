//
//  addItemToTableVCDelegate.h
//  ToDoList
//
//  Created by Taylor Ledingham on 2014-10-22.
//  Copyright (c) 2014 Taylor Ledingham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToDo.h"

@protocol addItemToTableVCDelegate <NSObject>

-(void)addItemtoListItemArray:(ToDo *)newItem ;
-(void)updateTable;

@end
