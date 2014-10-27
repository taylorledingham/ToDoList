//
//  ToDo.m
//  ToDoList
//
//  Created by Taylor Ledingham on 2014-10-22.
//  Copyright (c) 2014 Taylor Ledingham. All rights reserved.
//

#import "ToDo.h"

@implementation ToDo

@dynamic itemTitle;
@dynamic itemDesc;
@dynamic isCompleted;
@dynamic priority;
@dynamic completionDate;

- (NSString *)sectionName {
    
    return self.itemTitle;
}


@end
