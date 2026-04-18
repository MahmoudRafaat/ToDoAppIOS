//
//  AppDelegate.h
//  ToDoApp
//
//  Created by Mahmoud  Raafat  on 05/04/2026.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (readonly, strong) NSManagedObjectContext *context;

- (void)saveContext;

@end

