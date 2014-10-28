//
//  MasterViewController.m
//  ToDoList
//
//  Created by Taylor Ledingham on 2014-10-22.
//  Copyright (c) 2014 Taylor Ledingham. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

#define titleKey      @"Title"
#define descKey       @"Desc"
#define priorityKey   @"Priority"
#define dateKey       @"completionDate"
#define isCompleteKey    @"isComplete"


@interface MasterViewController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) NSMutableArray *toListItems;
@property (strong, nonatomic) NSMutableArray *deletedItems;


@end

@implementation MasterViewController {
     UIGestureRecognizer *tapGesture;
    NSDateFormatter *dateFormat;
    NSString *filePath;
    AppDelegate *appDelegate;
    NSURL *urlWithPath;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
   //self.toListItems = ((AppDelegate *)[[UIApplication sharedApplication].delegate).toDoItems;
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.toDoItems==nil)
    {
        self.toListItems = [[NSMutableArray alloc]init];
    }
    else {
        self.toListItems = appDelegate.toDoItems ;

    }
    
    NSDate *currDate = [NSDate date];
    ToDo *item1 = [[ToDo alloc]initWithTitle:@"To Do Task Name" andDesc:@"Task Description" andPriority:@2.0 andDate:currDate];
    
    
    //ToDo *item2 = [[ToDo alloc]initWithTitle:@"go to bank" andDesc:@"go to the bank" andPriority:3.0 andDate:currDate];
    
    
    //self.toListItems = [[NSMutableArray alloc]initWithObjects:item1, item2, nil];
    self.deletedItems = [[NSMutableArray alloc]init];
    
    [[NSUserDefaults standardUserDefaults]setObject:item1.itemTitle forKey:titleKey];
    [[NSUserDefaults standardUserDefaults]setObject:item1.itemDesc forKey:descKey];
    [[NSUserDefaults standardUserDefaults]setObject:item1.priority forKey:priorityKey];
    [[NSUserDefaults standardUserDefaults]setObject:item1.isCompleted forKey:isCompleteKey];
    [[NSUserDefaults standardUserDefaults]setObject:item1.completionDate forKey:dateKey];
    
    
   self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.tableView.allowsSelectionDuringEditing = YES;
    
    [self.fetchedResultsController performFetch:nil];
    dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM. dd 'at' hh:mm"];


    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Segues

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    if([identifier isEqualToString:@"showDetailItem"] && self.tableView.isEditing == YES){
        return NO;
    }
    
    return YES;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prepareForSegue??");
    if ([[segue identifier] isEqualToString:@"showDetailItem"]) {
       
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ToDo *object = [self.toListItems objectAtIndex:indexPath.row];
        
        AddItemTableViewController *detailVC = segue.destinationViewController;
        detailVC.displayOnly = YES;
        detailVC.entry = object;
        
    }
    
    if ([[segue identifier] isEqualToString:@"addItem"]) {
        
        AddItemTableViewController *addItemVC = segue.destinationViewController;
        
        if (self.tableView.editing == YES) {
            
            addItemVC.entry = sender;
            addItemVC.isEditing = YES;
            
        }
        
        
       // AddItemViewController *additem = (AddItemViewController *) addItemVC.topViewController;
        addItemVC.delegate = self;
        
    }
}

- (IBAction)startEditing:(id)sender
{
    self.editing = YES;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.toListItems.count;
}
- (ToDoItemTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ToDoItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.delegate = self;
    
    // Initialization code
    if (cell.swipeGesture == nil){
    cell.swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedRight:)];
    [cell.swipeGesture setDirection: UISwipeGestureRecognizerDirectionRight];
    [cell addGestureRecognizer:cell.swipeGesture];

    }
    
    ToDo *entry = self.toListItems[indexPath.row];
    cell.itemTitle.text  = entry.itemTitle;
    cell.itemDesc.text = entry.itemDesc;
    cell.itemPriority.text =[ NSString stringWithFormat:@"%.0f", [entry.priority floatValue]] ;
        NSString *theDate = [dateFormat stringFromDate:entry.completionDate];
    cell.completionDateLabel.text = [NSString stringWithFormat:@"%@", theDate];
    
    return cell;

}

//-(void)addItemtoListItemArray:(ToDo *)newItem {
//    
//    [self.toListItems addObject:newItem];
//    
//    NSUInteger index = [self.toListItems indexOfObject:newItem];
//    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//}

-(void)updateTable {
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.tableView.editing == YES){
    
        ToDo *curr = [self.toListItems objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"addItem" sender:curr];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    ToDo *toMove = self.toListItems[sourceIndexPath.row];
    [self.toListItems removeObjectAtIndex:sourceIndexPath.row];
    [self.toListItems insertObject:toMove atIndex:destinationIndexPath.row];
    
    [self.tableView reloadData];
    
}

-(UITableViewCellEditingStyle )tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return  UITableViewCellEditingStyleNone;
}


-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake )
    {
        // delete strike through cells
        NSPredicate *deletedItems = [NSPredicate predicateWithFormat:@"isCompleted == YES"];
        
        NSArray *fetchedObjects = [self.toListItems filteredArrayUsingPredicate:deletedItems];
        for( ToDo * entry in fetchedObjects) {
            
            [self.toListItems removeObject:entry];
        }
        
        [self.tableView reloadData];
        appDelegate.toDoItems = self.toListItems;
        [appDelegate saveData];


    }
}

-(void)swipedRight:(UIGestureRecognizer *)swipe{
    
    //add strike through to cell
   // CGPoint swipedPoint = [swipe locationInView:self.tableView];
    
    ToDoItemTableViewCell * cell = (ToDoItemTableViewCell *) swipe.view;
    
    NSIndexPath *swipedIndexPath = [self.tableView indexPathForCell:cell];
    
    ToDo *curr = [self.toListItems objectAtIndex:swipedIndexPath.row];
    
    
    curr.isCompleted = [NSNumber numberWithBool:YES];

    
    NSDictionary* attributes = @{
                                 NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]
                                 };
    
    NSAttributedString* attrText1 = [[NSAttributedString alloc] initWithString:cell.itemTitle.text attributes:attributes];
    
    NSAttributedString* attrText2 = [[NSAttributedString alloc] initWithString:cell.completionDateLabel.text attributes:attributes];
    
    cell.itemTitle.attributedText = attrText1;
    cell.completionDateLabel.attributedText = attrText2;
    
    
    
}

- (IBAction)saveItemsList:(id)sender {
    
    [NSKeyedArchiver archiveRootObject:self.toListItems toFile:filePath];
}

-(void)addItemtoListItemArray:(ToDo *)newItem{
    
    [self.toListItems addObject:newItem];
    appDelegate.toDoItems = self.toListItems;
    [appDelegate saveData];
    [self.tableView reloadData];
    
}


-(void) didPressCheckmarkButton:(ToDoItemTableViewCell *)cell {
    
    cell.checkToCompleteButton.hidden = NO;
    
    
}




@end
