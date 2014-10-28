//
//  ToDo.m
//  ToDoList
//
//  Created by Taylor Ledingham on 2014-10-22.
//  Copyright (c) 2014 Taylor Ledingham. All rights reserved.
//

#import "ToDo.h"

#define titleKey      @"Title"
#define descKey       @"Desc"
#define priorityKey   @"Priority"
#define dateKey       @"completionDate"

@implementation ToDo


- (instancetype)initWithTitle:(NSString *)title andDesc:(NSString *)desc andPriority:(NSNumber *)priority andDate:(NSDate *)date
{
    
    self = [self init];
    if (self) {
        self.itemTitle = title;
        self.itemDesc = desc;
        self.priority = priority;
        self.completionDate = date;
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.itemTitle forKey:titleKey];
    [encoder encodeObject:self.itemDesc forKey:descKey];
    [encoder encodeObject:self.priority forKey:priorityKey];
    [encoder encodeObject:self.completionDate forKey:dateKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [self init];
    self.itemTitle = [decoder decodeObjectForKey:titleKey];
    self.itemDesc = [decoder decodeObjectForKey:descKey];
    self.completionDate = [decoder decodeObjectForKey:dateKey];
    self.priority = [decoder decodeObjectForKey:priorityKey];
    return self;
}


@end
