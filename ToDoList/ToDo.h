//
//  ToDo.h
//  ToDoList
//
//  Created by Taylor Ledingham on 2014-10-22.
//  Copyright (c) 2014 Taylor Ledingham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ToDo : NSObject <NSCoding>

@property (copy, nonatomic) NSString *itemTitle;
@property (copy, nonatomic) NSString *itemDesc;
@property (copy, nonatomic) NSNumber * priority;
@property (copy, nonatomic) NSNumber* isCompleted;
@property (copy, nonatomic) NSDate *completionDate;



- (instancetype)initWithTitle:(NSString *)title andDesc:(NSString *)desc andPriority:(NSNumber *)priority andDate:(NSDate *)date;

@end
