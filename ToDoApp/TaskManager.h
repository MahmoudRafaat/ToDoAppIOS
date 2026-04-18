//
//  TaskManager.h
//  ToDoApp
//
//  Created by Mahmoud  Raafat  on 07/04/2026.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Task+CoreDataClass.h"
#import "Task+CoreDataProperties.h"

@interface TaskManager : NSObject

- (instancetype)initWithContext:(NSManagedObjectContext *)context;

- (void)addTaskWithTitle:(NSString *)title
                    desc:(NSString *)desc
                priority:(NSString *)priority
                creation:(NSDate *)creationDate
                 dueDate:(NSDate *)dueDate;

- (NSArray<Task *> *)fetchTasksWithStatus:(NSString *)status;
- (NSArray<Task *> *)fetchTasks;

- (void)deleteTask:(Task *)task;

@end

