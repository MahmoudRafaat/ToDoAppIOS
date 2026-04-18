//
//  Task+CoreDataProperties.m
//  ToDoApp
//
//  Created by Mahmoud  Raafat  on 08/04/2026.
//
//

#import "Task+CoreDataProperties.h"

@implementation Task (CoreDataProperties)

+ (NSFetchRequest<Task *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Task"];
}

@dynamic desc;
@dynamic dueDate;
@dynamic priotiy;
@dynamic statue;
@dynamic taskId;
@dynamic title;
@dynamic creationDate;

@end
