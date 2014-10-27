//
//  ToDo.h
//  ToDoList
//
//  Created by Taylor Ledingham on 2014-10-22.
//  Copyright (c) 2014 Taylor Ledingham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ToDo : NSManagedObject

@property (retain, nonatomic) NSString *itemTitle;
@property (retain, nonatomic) NSString *itemDesc;
@property (nonatomic) float priority;
@property (nonatomic) BOOL isCompleted;
@property (nonatomic) NSDate *completionDate;

@property (nonatomic, readonly) NSString *sectionName;


//- (instancetype)initWithTitle:(NSString *)title andDesc:(NSString *)desc andPriority:(int)priority andDate:(NSDate *)date;

@end
