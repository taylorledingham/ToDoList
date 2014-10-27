//
//  MasterViewController.m
//  ToDoList
//
//  Created by Taylor Ledingham on 2014-10-22.
//  Copyright (c) 2014 Taylor Ledingham. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) NSMutableArray *toListItems;
@property (strong, nonatomic) NSMutableArray *deletedItems;


@end

@implementation MasterViewController {
     UIGestureRecognizer *tapGesture;
    NSDateFormatter *dateFormat;

}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    self.deletedItems = [[NSMutableArray alloc]init];
    
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
        ToDo *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
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
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];}

- (ToDoItemTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ToDoItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.delegate = self;
    
    // Initialization code
    if (cell.swipeGesture == nil){
    cell.swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedRight:)];
    [cell.swipeGesture setDirection: UISwipeGestureRecognizerDirectionRight];
    [cell addGestureRecognizer:cell.swipeGesture];

    }
    
    ToDo *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.itemTitle.text  = entry.itemTitle;
    cell.itemDesc.text = entry.itemDesc;
    cell.itemPriority.text =[ NSString stringWithFormat:@"%.0f", entry.priority ] ;
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
    
    ToDo *curr = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
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
        TLCoreDataStack *coreDataStack = [TLCoreDataStack defaultStack];
        NSPredicate *deletedItems = [NSPredicate predicateWithFormat:@"isCompleted == YES"];
        NSFetchRequest *request = [self entryListFetchRequest];
        [request setPredicate:deletedItems];
        NSError *error = nil;
        
        NSArray *fetchedObjects = [coreDataStack.managedObjectContext executeFetchRequest:request error:&error];

        for( NSManagedObject * entry in fetchedObjects) {
            
            [[coreDataStack managedObjectContext] deleteObject:entry];
        }
        
        [coreDataStack saveContext];
        [self.tableView reloadData];
        

    }
}

-(void)swipedRight:(UIGestureRecognizer *)swipe{
    
    //add strike through to cell
   // CGPoint swipedPoint = [swipe locationInView:self.tableView];
    
    ToDoItemTableViewCell * cell = (ToDoItemTableViewCell *) swipe.view;
    
    NSIndexPath *swipedIndexPath = [self.tableView indexPathForCell:cell];
    
    //ToDo *curr = [self.toListItems objectAtIndex:swipedIndexPath.row];
    
    
    ToDo *curr = [self.fetchedResultsController objectAtIndexPath:swipedIndexPath];
    curr.isCompleted = YES;
    TLCoreDataStack *coreDataStack = [TLCoreDataStack defaultStack];
    [[coreDataStack managedObjectContext] updatedObjects];
    [coreDataStack saveContext];

    
    NSDictionary* attributes = @{
                                 NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]
                                 };
    
    NSAttributedString* attrText1 = [[NSAttributedString alloc] initWithString:cell.itemTitle.text attributes:attributes];
    
    NSAttributedString* attrText2 = [[NSAttributedString alloc] initWithString:cell.completionDateLabel.text attributes:attributes];
    
    cell.itemTitle.attributedText = attrText1;
    cell.completionDateLabel.attributedText = attrText2;
    
    
    
}


-(void) didPressCheckmarkButton:(ToDoItemTableViewCell *)cell {
    
    cell.checkToCompleteButton.hidden = NO;
    
    
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    TLCoreDataStack *coreDataStack = [TLCoreDataStack defaultStack];
    NSFetchRequest *fetchRequest = [self entryListFetchRequest];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:coreDataStack.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}


-(NSFetchRequest *)entryListFetchRequest {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ToDo"];
    
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"priority" ascending:NO]];
    
    return fetchRequest;
}


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            //[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}



@end
