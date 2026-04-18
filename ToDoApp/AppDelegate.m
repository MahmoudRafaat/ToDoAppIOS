//
//  AppDelegate.m
//  ToDoApp
//
//  Created by Mahmoud  Raafat  on 05/04/2026.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}
#pragma mark - Core Data Stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    if (_persistentContainer != nil) return _persistentContainer;

    _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Tasks"];

    [_persistentContainer loadPersistentStoresWithCompletionHandler:^(
        NSPersistentStoreDescription *desc, NSError *error) {
        if (error) {
            NSLog(@"Core Data failed to load: %@", error);
            abort();
        }
    }];

    _persistentContainer.viewContext.automaticallyMergesChangesFromParent = YES;
    return _persistentContainer;
}

- (NSManagedObjectContext *)context {
    return self.persistentContainer.viewContext;
}

- (void)saveContext {
    NSManagedObjectContext *ctx = self.persistentContainer.viewContext;
    if (ctx.hasChanges) {
        NSError *error = nil;
        if (![ctx save:&error]) {
            NSLog(@"Save error: %@", error);
        }
    }
}


@end
