//
//  EditViewController.h
//  ToDoApp
//
//  Created by Mahmoud  Raafat  on 07/04/2026.
//

#import <UIKit/UIKit.h>
#import "Task+CoreDataClass.h"
NS_ASSUME_NONNULL_BEGIN

@interface EditViewController : UIViewController
@property (strong, nonatomic) Task *selectedTask; 
@end

NS_ASSUME_NONNULL_END
