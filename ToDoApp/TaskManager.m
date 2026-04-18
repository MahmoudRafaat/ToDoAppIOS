//
//  TaskManager.m
//  ToDoApp
//
//  Created by Mahmoud  Raafat  on 07/04/2026.
//

#import "TaskManager.h"

@interface TaskManager ()
@property (strong, nonatomic) NSManagedObjectContext *context;
@end

@implementation TaskManager

- (instancetype)initWithContext:(NSManagedObjectContext *)context {
    self = [super init];
    if (self) { _context = context; }
    return self;
}

- (void)addTaskWithTitle:(NSString *)title
                    desc:(NSString *)desc
                priority:(NSString *)priority
                creation:(NSDate *)creationDate
                 dueDate:(NSDate *)dueDate {

    Task *task = [NSEntityDescription insertNewObjectForEntityForName:@"Task"
                                               inManagedObjectContext:self.context];
    task.taskId       = [NSUUID UUID];
    task.title    = title;
    task.desc     = desc;
    task.priotiy = priority;
    task.dueDate  = dueDate;
    task.creationDate=creationDate;
    task.statue   = @"todo";
    [self save];
}

- (NSArray<Task *> *)fetchTasksWithStatus:(NSString *)status {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
    request.predicate = [NSPredicate predicateWithFormat:@"statue == %@", status];
    request.sortDescriptors = @[
        [NSSortDescriptor sortDescriptorWithKey:@"dueDate" ascending:YES]
    ];
    NSError *error = nil;
    NSArray *results = [self.context executeFetchRequest:request error:&error];
    if (error) { NSLog(@"Fetch error: %@", error); return @[]; }
    return results ?: @[];
}
- (NSArray<Task *> *)fetchTasks {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
    
    request.sortDescriptors = @[
        [NSSortDescriptor sortDescriptorWithKey:@"dueDate" ascending:YES]
    ];
    NSError *error = nil;
    NSArray *results = [self.context executeFetchRequest:request error:&error];
    if (error) { NSLog(@"Fetch error: %@", error); return @[]; }
    return results ?: @[];
}



- (void)deleteTask:(Task *)task {
    [self.context deleteObject:task];
    [self save];
}

- (void)save {
    if (self.context.hasChanges) {
        NSError *error = nil;
        if (![self.context save:&error]) {
            NSLog(@"Save error: %@", error);
        }
    }
}

@end
