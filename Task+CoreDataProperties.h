//
//  Task+CoreDataProperties.h
//  ToDoApp
//
//  Created by Mahmoud  Raafat  on 08/04/2026.
//
//

#import "Task+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Task (CoreDataProperties)

+ (NSFetchRequest<Task *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, copy) NSString *desc;
@property (nullable, nonatomic, copy) NSDate *dueDate;
@property (nullable, nonatomic, copy) NSString *priotiy;
@property (nullable, nonatomic, copy) NSString *statue;
@property (nullable, nonatomic, copy) NSUUID *taskId;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSDate *creationDate;

@end

NS_ASSUME_NONNULL_END
