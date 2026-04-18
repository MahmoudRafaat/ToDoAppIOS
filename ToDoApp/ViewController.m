//
//  ViewController.m
//  ToDoApp
//
//  Created by Mahmoud  Raafat  on 05/04/2026.
//
#import "ViewController.h"
#import "AddTaskViewController.h"
#import "TaskManager.h"
#import "AppDelegate.h"
#import "EditViewController.h"

#define BG_COLOR         [UIColor blackColor]
#define CARD_COLOR       [UIColor colorWithRed:0.15 green:0.15 blue:0.17 alpha:1]
#define MUTED_COLOR      [UIColor colorWithRed:0.55 green:0.55 blue:0.58 alpha:1]
#define BLUE_ACCENT      [UIColor colorWithRed:0.04 green:0.52 blue:1.00 alpha:1]
#define RED_PRIORITY     [UIColor colorWithRed:1.00 green:0.27 blue:0.23 alpha:1]
#define ORANGE_PRIORITY  [UIColor colorWithRed:1.00 green:0.62 blue:0.04 alpha:1]
#define GREEN_PRIORITY   [UIColor colorWithRed:0.19 green:0.82 blue:0.35 alpha:1]

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *noTasksImage;
@property (weak, nonatomic) IBOutlet UILabel     *showDate;
@property (weak, nonatomic) IBOutlet UIButton    *addButton;
@property (weak, nonatomic) IBOutlet UILabel     *emptyTasks;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tasksState;
@property (weak, nonatomic) IBOutlet UITableView  *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar  *searchBar;
@property (strong, nonatomic) TaskManager         *manager;
@property (strong, nonatomic) NSArray<Task *>     *tasks;
@property (strong, nonatomic) NSArray<Task *>     *highTasks;
@property (strong, nonatomic) NSArray<Task *>     *mediumTasks;
@property (strong, nonatomic) NSArray<Task *>     *lowTasks;
@property (strong, nonatomic) UIView             *headerContainer;
@property (strong, nonatomic) UILabel            *titleLabel;
@property (strong, nonatomic) UILabel            *dateLabel;
@property (strong, nonatomic) UISearchBar        *customSearchBar;
@property (strong, nonatomic) UISegmentedControl *customSegment;
@end

@implementation ViewController

- (IBAction)changeSegment:(id)sender {
    self.tasksState.selectedSegmentIndex = self.customSegment.selectedSegmentIndex;
    [self loadData];
}

- (IBAction)goToAddTask:(id)sender {
    AddTaskViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"addTaskScreen"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.manager = [[TaskManager alloc] initWithContext:app.persistentContainer.viewContext];
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    [self hideStoryboardConflicts];
    [self styleNavBar];
    [self buildProgrammaticHeader];
    [self styleTableView];
    [self styleEmptyState];
    [self styleFAB];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
    [self.view bringSubviewToFront:self.addButton];
    [self.view bringSubviewToFront:self.emptyTasks];
    [self.view bringSubviewToFront:self.noTasksImage];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self relayout];
}

- (void)hideStoryboardConflicts {
    self.view.backgroundColor = BG_COLOR;
    self.showDate.hidden       = YES;
    self.searchBar.hidden      = YES;
    self.tasksState.hidden     = YES;
    for (UIView *v in self.view.subviews) {
        if ([v isKindOfClass:[UILabel class]]) {
            UILabel *l = (UILabel *)v;
            if (l != self.emptyTasks && l != self.showDate) l.hidden = YES;
        }
    }
}

- (void)styleNavBar {
    self.navigationItem.title = nil;
    UINavigationBarAppearance *a = [[UINavigationBarAppearance alloc] init];
    [a configureWithOpaqueBackground];
    a.backgroundColor      = BG_COLOR;
    a.shadowColor          = [UIColor clearColor];
    a.titleTextAttributes  = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    a.largeTitleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.standardAppearance   = a;
    self.navigationController.navigationBar.scrollEdgeAppearance = a;
    self.navigationController.navigationBar.tintColor            = BLUE_ACCENT;
    self.navigationController.navigationBar.prefersLargeTitles   = NO;
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
}

- (void)buildProgrammaticHeader {
    UIView *container = [[UIView alloc] init];
    container.backgroundColor = BG_COLOR;
    [self.view addSubview:container];
    self.headerContainer = container;

    UILabel *title = [[UILabel alloc] init];
    title.text      = @"Taskly";
    title.font      = [UIFont systemFontOfSize:34 weight:UIFontWeightBold];
    title.textColor = [UIColor whiteColor];
    [container addSubview:title];
    self.titleLabel = title;

    UILabel *date = [[UILabel alloc] init];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"EEEE, d MMM"];
    date.text      = [df stringFromDate:[NSDate date]];
    date.font      = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    date.textColor = MUTED_COLOR;
    [container addSubview:date];
    self.dateLabel = date;

    UISearchBar *sb = [[UISearchBar alloc] init];
    sb.searchBarStyle  = UISearchBarStyleMinimal;
    sb.placeholder     = @"Search tasks...";
    sb.barTintColor    = BG_COLOR;
    sb.backgroundColor = BG_COLOR;
    sb.delegate        = self;
    UITextField *sf = [sb valueForKey:@"searchField"];
    if (sf) {
        sf.backgroundColor = CARD_COLOR;
        sf.textColor       = [UIColor whiteColor];
        sf.tintColor       = BLUE_ACCENT;
        sf.font            = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        sf.layer.cornerRadius = 12;
        sf.clipsToBounds   = YES;
        [sf setAttributedPlaceholder:[[NSAttributedString alloc]
            initWithString:@"Search tasks..."
            attributes:@{NSForegroundColorAttributeName: MUTED_COLOR}]];
        UIImageView *icon = (UIImageView *)sf.leftView;
        icon.tintColor = MUTED_COLOR;
    }
    [container addSubview:sb];
    self.customSearchBar = sb;

    UISegmentedControl *seg = [[UISegmentedControl alloc]
        initWithItems:@[@"All", @"Todo", @"In Progress", @"Done", @"Priority"]];
    seg.selectedSegmentIndex     = 0;
    seg.backgroundColor          = CARD_COLOR;
    seg.selectedSegmentTintColor = BLUE_ACCENT;
    seg.layer.cornerRadius       = 12;
    seg.clipsToBounds            = YES;
    [seg setTitleTextAttributes:@{
        NSForegroundColorAttributeName: MUTED_COLOR,
        NSFontAttributeName: [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold]
    } forState:UIControlStateNormal];
    [seg setTitleTextAttributes:@{
        NSForegroundColorAttributeName: [UIColor whiteColor],
        NSFontAttributeName: [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold]
    } forState:UIControlStateSelected];
    [seg addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    [container addSubview:seg];
    self.customSegment = seg;
}

- (void)segmentChanged:(UISegmentedControl *)sender {
    self.tasksState.selectedSegmentIndex = sender.selectedSegmentIndex;
    [self loadData];
}

- (void)relayout {
    CGFloat safeTop = self.view.safeAreaInsets.top;
    CGFloat w       = self.view.bounds.size.width;
    CGFloat h       = self.view.bounds.size.height;
    CGFloat pad     = 16;
    CGFloat titleY  = safeTop + 12;
    CGFloat titleH  = 40;
    CGFloat dateH   = 20;
    CGFloat searchH = 44;
    CGFloat segH    = 36;
    CGFloat spacing = 8;
    CGFloat totalH  = titleH + spacing + dateH + spacing + searchH + spacing + segH + 12;

    self.headerContainer.frame = CGRectMake(0, 0, w, safeTop + totalH);
    self.titleLabel.frame      = CGRectMake(pad, titleY, w - pad * 2, titleH);
    self.dateLabel.frame       = CGRectMake(pad, titleY + titleH + spacing, w - pad * 2, dateH);
    self.customSearchBar.frame = CGRectMake(pad - 8, titleY + titleH + spacing + dateH + spacing, w - (pad - 8) * 2, searchH);
    self.customSegment.frame   = CGRectMake(pad, titleY + titleH + spacing + dateH + spacing + searchH + spacing, w - pad * 2, segH);

    CGFloat tableTop = safeTop + totalH;
    self.tableView.frame = CGRectMake(0, tableTop, w, h - tableTop);

    CGFloat midY = tableTop + (h - tableTop) / 2;
    self.noTasksImage.frame = CGRectMake(w / 2 - 44, midY - 120, 88, 88);
    self.emptyTasks.frame   = CGRectMake(pad, midY - 24, w - pad * 2, 52);

    self.addButton.frame = CGRectMake(w - 72, h - 96, 56, 56);
    [self.view bringSubviewToFront:self.addButton];
}

- (void)styleTableView {
    self.tableView.backgroundColor              = BG_COLOR;
    self.tableView.separatorStyle               = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.contentInset                 = UIEdgeInsetsMake(8, 0, 100, 0);
}

- (void)styleEmptyState {
    self.emptyTasks.text          = @"No tasks here.\nTap + to add one.";
    self.emptyTasks.numberOfLines = 2;
    self.emptyTasks.textAlignment = NSTextAlignmentCenter;
    self.emptyTasks.font          = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    self.emptyTasks.textColor     = MUTED_COLOR;
    self.noTasksImage.alpha       = 0.4;
    self.noTasksImage.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)styleFAB {
    self.addButton.backgroundColor     = BLUE_ACCENT;
    self.addButton.layer.cornerRadius   = 28;
    self.addButton.layer.masksToBounds  = YES;
    self.addButton.tintColor            = [UIColor whiteColor];
    UIButtonConfiguration *cfg          = [UIButtonConfiguration filledButtonConfiguration];
    cfg.image                           = [UIImage systemImageNamed:@"plus"
                                           withConfiguration:[UIImageSymbolConfiguration
                                           configurationWithPointSize:24
                                           weight:UIImageSymbolWeightMedium]];
    cfg.baseBackgroundColor             = BLUE_ACCENT;
    cfg.baseForegroundColor             = [UIColor whiteColor];
    cfg.cornerStyle                     = UIButtonConfigurationCornerStyleCapsule;
    self.addButton.configuration        = cfg;
}

- (void)loadData {
    NSInteger idx = self.customSegment.selectedSegmentIndex;
    switch (idx) {
        case 0: self.tasks = [self.manager fetchTasks];                         break;
        case 1: self.tasks = [self.manager fetchTasksWithStatus:@"todo"];       break;
        case 2: self.tasks = [self.manager fetchTasksWithStatus:@"inprogress"]; break;
        case 3: self.tasks = [self.manager fetchTasksWithStatus:@"done"];       break;
        case 4: self.tasks = [self.manager fetchTasks];                         break;
        default: break;
    }
    NSString *trimmed = [self.customSearchBar.text
        stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (trimmed.length > 0) {
        self.tasks = [self.tasks filteredArrayUsingPredicate:
            [NSPredicate predicateWithFormat:@"title BEGINSWITH[c] %@", trimmed]];
    }
    if (idx == 4) {
        self.highTasks   = [self.tasks filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"priotiy == %@", @"High"]];
        self.mediumTasks = [self.tasks filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"priotiy == %@", @"Medium"]];
        self.lowTasks    = [self.tasks filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"priotiy == %@", @"Low"]];
    }
    BOOL isEmpty = (self.tasks.count == 0);
    self.emptyTasks.hidden   = !isEmpty;
    self.noTasksImage.hidden = !isEmpty;
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.customSegment.selectedSegmentIndex == 4) {
        return (self.tasks.count == 0) ? 1 : 3;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.customSegment.selectedSegmentIndex == 4) {
        if (self.tasks.count == 0) return 0;
        if (section == 0) return self.highTasks.count;
        if (section == 1) return self.mediumTasks.count;
        return self.lowTasks.count;
    }
    return self.tasks.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 86.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;

    Task *task;
    NSInteger idx = self.customSegment.selectedSegmentIndex;
    if (idx == 4) {
        if (indexPath.section == 0)      task = self.highTasks[indexPath.row];
        else if (indexPath.section == 1) task = self.mediumTasks[indexPath.row];
        else                             task = self.lowTasks[indexPath.row];
    } else {
        task = self.tasks[indexPath.row];
    }

    UIColor *priorityColor;
    NSString *priorityLabel;
    NSString *priorityImageName;
    if ([task.priotiy isEqualToString:@"High"]) {
        priorityColor     = RED_PRIORITY;
        priorityLabel     = @"High";
        priorityImageName = @"icons8-high-importance-48-red";
    } else if ([task.priotiy isEqualToString:@"Medium"]) {
        priorityColor     = ORANGE_PRIORITY;
        priorityLabel     = @"Med";
        priorityImageName = @"icons8-high-importance-48-yellow";
    } else {
        priorityColor     = GREEN_PRIORITY;
        priorityLabel     = @"Low";
        priorityImageName = @"icons8-high-importance-48-green";
    }

    UIColor *statusColor;
    if ([task.statue isEqualToString:@"done"])            statusColor = GREEN_PRIORITY;
    else if ([task.statue isEqualToString:@"inprogress"]) statusColor = ORANGE_PRIORITY;
    else                                                  statusColor = BLUE_ACCENT;

    CGFloat cardW = tableView.frame.size.width - 32;

    UIView *card = [cell.contentView viewWithTag:100];
    if (!card) {
        card = [[UIView alloc] init];
        card.tag                 = 100;
        card.layer.cornerRadius  = 18;
        card.layer.masksToBounds = YES;
        [cell.contentView insertSubview:card atIndex:0];
    }
    card.backgroundColor = CARD_COLOR;
    card.frame = CGRectMake(16, 6, cardW, 74);

    UIView *bar = [card viewWithTag:101];
    if (!bar) {
        bar = [[UIView alloc] init];
        bar.tag                = 101;
        bar.layer.cornerRadius = 2;
        [card addSubview:bar];
    }
    bar.backgroundColor = priorityColor;
    bar.frame = CGRectMake(0, 12, 4, 50);

    UIImageView *iconView = [card viewWithTag:107];
    if (!iconView) {
        iconView = [[UIImageView alloc] init];
        iconView.tag         = 107;
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        [card addSubview:iconView];
    }
    iconView.image = [UIImage imageNamed:priorityImageName];
    iconView.frame = CGRectMake(14, 17, 36, 36);

    UILabel *titleLbl = [card viewWithTag:102];
    if (!titleLbl) {
        titleLbl           = [[UILabel alloc] init];
        titleLbl.tag       = 102;
        titleLbl.font      = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        titleLbl.textColor = [UIColor whiteColor];
        [card addSubview:titleLbl];
    }
    titleLbl.text  = task.title;
    titleLbl.frame = CGRectMake(60, 12, cardW - 130, 24);

    UILabel *dateLbl = [card viewWithTag:103];
    if (!dateLbl) {
        dateLbl           = [[UILabel alloc] init];
        dateLbl.tag       = 103;
        dateLbl.font      = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        dateLbl.textColor = MUTED_COLOR;
        [card addSubview:dateLbl];
    }
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"d MMM yyyy, HH:mm"];
    dateLbl.text  = [NSString stringWithFormat:@"Created  %@", [fmt stringFromDate:task.creationDate]];
    dateLbl.frame = CGRectMake(60, 40, cardW - 130, 18);

    UIView *pill = [card viewWithTag:104];
    if (!pill) {
        pill                     = [[UIView alloc] init];
        pill.tag                 = 104;
        pill.layer.cornerRadius  = 11;
        pill.layer.masksToBounds = YES;
        [card addSubview:pill];
    }
    pill.backgroundColor = [priorityColor colorWithAlphaComponent:0.20];
    pill.frame = CGRectMake(cardW - 68, 23, 56, 26);

    UILabel *pillLbl = [pill viewWithTag:105];
    if (!pillLbl) {
        pillLbl               = [[UILabel alloc] init];
        pillLbl.tag           = 105;
        pillLbl.font          = [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
        pillLbl.textAlignment = NSTextAlignmentCenter;
        [pill addSubview:pillLbl];
    }
    pillLbl.textColor = priorityColor;
    pillLbl.text      = priorityLabel;
    pillLbl.frame     = pill.bounds;

    UIView *dot = [card viewWithTag:106];
    if (!dot) {
        dot                    = [[UIView alloc] init];
        dot.tag                = 106;
        dot.layer.cornerRadius = 5;
        [card addSubview:dot];
    }
    dot.backgroundColor = statusColor;
    dot.frame = CGRectMake(cardW - 16, 8, 10, 10);

    cell.textLabel.text       = nil;
    cell.detailTextLabel.text = nil;
    cell.imageView.image      = nil;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header      = [[UIView alloc] init];
    header.backgroundColor = BG_COLOR;
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 300, 24)];
    lbl.font      = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
    lbl.textColor = MUTED_COLOR;
    NSInteger idx = self.customSegment.selectedSegmentIndex;
    if (idx == 4) {
        if (self.tasks.count == 0) {
            lbl.text = @"PRIORITY TASKS";
        } else {
            NSArray *titles = @[@"HIGH PRIORITY", @"MEDIUM PRIORITY", @"LOW PRIORITY"];
            lbl.text = (section < titles.count) ? titles[section] : @"";
        }
    } else {
        NSArray *titles = @[@"ALL TASKS", @"TO DO", @"IN PROGRESS", @"DONE", @"PRIORITY"];
        lbl.text = (idx < titles.count) ? titles[idx] : @"";
    }
    [header addSubview:lbl];
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Task *selected;
    NSInteger idx = self.customSegment.selectedSegmentIndex;
    if (idx == 4 && self.tasks.count > 0) {
        if (indexPath.section == 0)      selected = self.highTasks[indexPath.row];
        else if (indexPath.section == 1) selected = self.mediumTasks[indexPath.row];
        else                             selected = self.lowTasks[indexPath.row];
    } else {
        selected = self.tasks[indexPath.row];
    }
    EditViewController *editVC = [self.storyboard instantiateViewControllerWithIdentifier:@"editTaskScreen"];
    editVC.selectedTask = selected;
    [self.navigationController pushViewController:editVC animated:YES];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView
trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    Task *toDelete;
    NSInteger idx = self.customSegment.selectedSegmentIndex;
    if (idx == 4 && self.tasks.count > 0) {
        if (indexPath.section == 0)      toDelete = self.highTasks[indexPath.row];
        else if (indexPath.section == 1) toDelete = self.mediumTasks[indexPath.row];
        else                             toDelete = self.lowTasks[indexPath.row];
    } else {
        toDelete = self.tasks[indexPath.row];
    }
    UIContextualAction *del = [UIContextualAction
        contextualActionWithStyle:UIContextualActionStyleDestructive
        title:nil
        handler:^(UIContextualAction *a, UIView *src, void(^done)(BOOL)) {
            UIAlertController *alert = [UIAlertController
                alertControllerWithTitle:@"Delete Task"
                message:@"This action cannot be undone."
                preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Delete"
                style:UIAlertActionStyleDestructive
                handler:^(UIAlertAction *ac) {
                    [self.manager deleteTask:toDelete];
                    [self loadData];
                    done(YES);
                }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                style:UIAlertActionStyleCancel
                handler:^(UIAlertAction *ac) { done(NO); }]];
            [self presentViewController:alert animated:YES completion:nil];
        }];
    del.image           = [UIImage systemImageNamed:@"trash.fill"];
    del.backgroundColor = RED_PRIORITY;
    UISwipeActionsConfiguration *cfg = [UISwipeActionsConfiguration configurationWithActions:@[del]];
    cfg.performsFirstActionWithFullSwipe = NO;
    return cfg;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self loadData];
}

@end
