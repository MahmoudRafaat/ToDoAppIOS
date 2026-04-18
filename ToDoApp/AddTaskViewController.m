//
//  AddTaskViewController.m
//  ToDoApp
//
//  Created by Mahmoud  Raafat  on 07/04/2026.
//

#import "AddTaskViewController.h"
#import "TaskManager.h"
#import "AppDelegate.h"
@interface AddTaskViewController ()
@property (weak, nonatomic) IBOutlet UILabel *creationDate;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UIDatePicker *dueDate;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priority;
@property (weak, nonatomic) IBOutlet UITextView *desc;
@property  TaskManager *taskManager;

@end

@implementation AddTaskViewController
- (IBAction)addTask:(id)sender {
   
    NSString *title = self.titleField.text;

    if (title.length == 0) {
        UIAlertController *alert = [UIAlertController
            alertControllerWithTitle:@"Missing Title"
            message:@"Please enter a task title."
            preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                  style:UIAlertActionStyleDefault
                                                handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }


    NSString *descText = self.desc.text;


    NSString *priorityText;
    switch (self.priority.selectedSegmentIndex) {
        case 0:
            priorityText = @"High";
            break;
        case 1:
            priorityText = @"Medium";
            break;
        case 2:
            priorityText = @"Low";
            break;
        default:
            priorityText = @"High";
            break;
    }

  
    NSDate *selectedDate = self.dueDate.date;
    NSDate *currentDate = [NSDate date];
    

    [self.taskManager addTaskWithTitle:title
                                  desc:descText
                              priority:priorityText
                              creation:currentDate
                               dueDate:selectedDate];


    [self.navigationController popViewControllerAnimated:YES];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // In viewDidLoad

    self.titleField.backgroundColor = [UIColor systemGray6Color];
    self.titleField.borderStyle = UITextBorderStyleNone;
    self.titleField.layer.cornerRadius = 10;
    self.titleField.clipsToBounds = YES;

    self.desc.backgroundColor = [UIColor systemGray6Color];
    self.desc.layer.cornerRadius = 10;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.taskManager = [[TaskManager alloc] initWithContext:appDelegate.persistentContainer.viewContext];
    self.dueDate.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
    self.navigationItem.title=@"New Task";
    self.navigationItem.largeTitleDisplayMode=YES;
    [self.navigationController.navigationBar setLargeTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE, d MMM, HH:mm"];

    self.creationDate.text = [NSString stringWithFormat:@"Created at : %@", [formatter stringFromDate:today]];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
