//
//  EditViewController.m
//  ToDoApp
//
//  Created by Mahmoud  Raafat  on 07/04/2026.
//

#import "EditViewController.h"

@interface EditViewController ()
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UILabel *creationDate;
@property (weak, nonatomic) IBOutlet UIDatePicker *dueDate;
@property (weak, nonatomic) IBOutlet UISegmentedControl *status;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prority;
@property (weak, nonatomic) IBOutlet UITextView *desc;
@property (weak, nonatomic) IBOutlet UITextField *titleTask;

@end

@implementation EditViewController
- (IBAction)editTask:(id)sender {
    self.selectedTask.title = self.titleTask.text;
        self.selectedTask.desc = self.desc.text;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, d MMM, HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:self.selectedTask.creationDate];

    self.creationDate.text=[NSString stringWithFormat:@"creation: %@",  dateString];
    

        
        if (self.prority.selectedSegmentIndex == 0) self.selectedTask.priotiy = @"High";
        else if (self.prority.selectedSegmentIndex == 1) self.selectedTask.priotiy = @"Medium";
        else self.selectedTask.priotiy = @"Low";
        
      
        if (self.status.selectedSegmentIndex == 0) self.selectedTask.statue = @"todo";
        else if (self.status.selectedSegmentIndex == 1) self.selectedTask.statue = @"inprogress";
        else self.selectedTask.statue = @"done";
        
        NSError *error = nil;
        if (![self.selectedTask.managedObjectContext save:&error]) {
            NSLog(@"Error saving edited task: %@", error);
        } else {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dueDate.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
    if (self.selectedTask) {
           
            self.titleTask.text = self.selectedTask.title;
            self.desc.text = self.selectedTask.desc;
            self.dueDate.date = self.selectedTask.dueDate;
            
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE, d MMM, HH:mm"];
        NSString *dateString = [dateFormatter stringFromDate:self.selectedTask.creationDate];

        self.creationDate.text=[NSString stringWithFormat:@"creation: %@",  dateString];
            if ([self.selectedTask.priotiy isEqualToString:@"High"]) {
                self.prority.selectedSegmentIndex = 0;
            } else if ([self.selectedTask.priotiy isEqualToString:@"Medium"]) {
                self.prority.selectedSegmentIndex = 1;
            } else {
                self.prority.selectedSegmentIndex = 2;
            }
            
            if ([self.selectedTask.statue isEqualToString:@"todo"]) {
                self.status.selectedSegmentIndex = 0;
            } else if ([self.selectedTask.statue isEqualToString:@"inprogress"]) {
                self.status.selectedSegmentIndex = 1;
            } else {
                self.status.selectedSegmentIndex = 2;
            }
        if ([self.selectedTask.statue isEqualToString:@"inprogress"]) {
                    [self.status setEnabled:NO forSegmentAtIndex:0];
                }
                else if ([self.selectedTask.statue isEqualToString:@"done"]) {
                    self.status.enabled = NO;
                     self.titleTask.enabled = NO;
                     self.desc.editable = NO;
                     self.dueDate.enabled = NO;
                     self.prority.enabled = NO;
                    self.saveButton.enabled=NO;
                }
}
    self.navigationItem.title=@"Your Task";
    self.navigationItem.largeTitleDisplayMode=YES;
    [self.navigationController.navigationBar setLargeTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
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
