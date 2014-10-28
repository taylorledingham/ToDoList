//
//  AddItemTableViewController.m
//  ToDoList
//
//  Created by Taylor Ledingham on 2014-10-24.
//  Copyright (c) 2014 Taylor Ledingham. All rights reserved.
//

#import "AddItemTableViewController.h"

#define titleKey      @"Title"
#define descKey       @"Desc"
#define priorityKey   @"Priority"
#define dateKey       @"completionDate"
#define isCompleteKey    @"isComplete"


@interface AddItemTableViewController ()

@end

@implementation AddItemTableViewController {
    
    UITapGestureRecognizer *tapRecognizer;
    UITapGestureRecognizer *cellTapRecognizer;
    BOOL isCellExpanded;
    NSDateFormatter *dateFormat;
    NSString *cacheDirectory;
    NSString *filePath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isCellExpanded = NO;
    self.descTextView.delegate = self;
    self.titleTextField.delegate = self;
    self.itemDatePicker.hidden = YES;
    dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM. dd 'at' hh:mm"];
    cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    filePath = [cacheDirectory stringByAppendingPathComponent:@"entryData"];
    
    self.navigationController.delegate = self;

    
    //[self.tableView registerClass:[UITableViewCell class] forCellWithReuseIdentifier:@"DateCell"];
    
    if( self.isEditing == YES){
        [self setTableForEditing];
    }
    else if(self.displayOnly == YES ){
        [self setTableForDisplayOnly];
    }
    else {
 
//    NSDate *currDate = [NSDate date];
//    NSString *theDate = [dateFormat stringFromDate:currDate];
//    self.dateValueLabel.text = [NSString stringWithFormat:@"%@", theDate];
        self.entry = [[ToDo alloc]init];
        self.entry.completionDate = [NSDate date];
        [self setTableForAdding];
        [self loadFromCache];
    }

}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if(viewController != self){
        NSLog(@"go back");
        if(self.displayOnly != YES){
            [self removeFromCache];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated {
    UINavigationItem *navItem = self.navigationItem;
    UIBarButtonItem *backbutton = navItem.backBarButtonItem;
    
    [backbutton setAction:@selector(goBackToMasterView)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTableForAdding {
    
    self.titleTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:titleKey];
    self.descTextView.text = [[NSUserDefaults standardUserDefaults] objectForKey:descKey];
    self.priorityNumberLabel.text = [NSString stringWithFormat:@" %@", [[NSUserDefaults standardUserDefaults] objectForKey:priorityKey]];
    self.prioritySlider.value = [[[NSUserDefaults standardUserDefaults] objectForKey:priorityKey] floatValue];
    NSString *toDoDate = [dateFormat stringFromDate:[[NSUserDefaults standardUserDefaults] objectForKey:dateKey]];
    self.dateValueLabel.text = toDoDate;
    self.itemDatePicker.date = [[NSUserDefaults standardUserDefaults] objectForKey:dateKey];
    
}

-(void)setTableForEditing {
    
    self.titleTextField.text = self.entry.itemTitle;
    self.descTextView.text = self.entry.itemDesc;
    self.priorityNumberLabel.text = [NSString stringWithFormat:@" %@", self.entry.priority];
    self.prioritySlider.value = [self.entry.priority floatValue];
    NSString *toDoDate = [dateFormat stringFromDate:self.entry.completionDate];
    self.dateValueLabel.text = toDoDate;
    self.itemDatePicker.date = self.entry.completionDate;
}

-(void)setTableForDisplayOnly {
    
    [self setTableForEditing];
    
    self.titleTextField.userInteractionEnabled = NO;
    self.descTextView.userInteractionEnabled = NO;
    self.prioritySlider.userInteractionEnabled = NO;
    self.itemDatePicker.userInteractionEnabled = NO;
    
}

- (void)updateToDoEntry {
    self.entry.itemTitle = self.titleTextField.text;
    self.entry.itemDesc = self.descTextView.text;
    self.entry.priority = [NSNumber numberWithFloat: self.prioritySlider.value];
    self.entry.completionDate = self.itemDatePicker.date;
    
}


#pragma mark - text field delegates

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // do whatever you have to do
    if(textField == self.titleTextField){
        [textField resignFirstResponder];
        //[self.descTextView becomeFirstResponder];
        
    }
    
    // [textField resignFirstResponder];
    
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(didTapAnywhere:)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    
}


-(void) textFieldDidEndEditing:(UITextField *)textField {
    
    self.entry.itemTitle = textField.text;
    [self saveToCache];
    [textField resignFirstResponder];
    
}

-(void) textViewDidEndEditing:(UITextView *)textView {
    self.entry.itemDesc = textView.text;
    [self saveToCache];
    [textView resignFirstResponder];
}


-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer {
    [self.descTextView resignFirstResponder];
    [self.view removeGestureRecognizer:tapRecognizer];
    [self.view endEditing:YES];
    
    
}


#pragma mark - Table view data source


-(UITableViewCellEditingStyle )tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return  UITableViewCellEditingStyleNone;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if(self.displayOnly == NO) {
    
    if(indexPath.section == 1 && indexPath.row == 0){
        
        isCellExpanded = YES;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cellTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                    action:@selector(didTapOnDateCell:)];
        [cell addGestureRecognizer:cellTapRecognizer];
        self.itemDatePicker.hidden = NO;
    }
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0)
    {
        return 50.0;
    }
    
    else if (indexPath.section == 1 && indexPath.row){
        
        if(isCellExpanded){
            return 150;
        }
        
        return 45.0;
    }
    
    else if (indexPath.section == 2){
        return 85;
    }
    
    else if(indexPath.section == 3){
        return 200;
    }
    return 50;
}




-(void)didTapOnDateCell:(UITapGestureRecognizer *)tap {
    
    if(self.displayOnly == NO) {
    
    self.itemDatePicker.hidden = YES;
    isCellExpanded = NO;
    
    [tap.view removeGestureRecognizer:tap];
   [self.tableView beginUpdates];
   [self.tableView endUpdates];
    }
    
}

- (IBAction)priorityValueDidChange:(id)sender {
    
    self.priorityNumberLabel.text = [NSString stringWithFormat:@"%.0f", self.prioritySlider.value];
    self.entry.priority = [NSNumber numberWithFloat:self.prioritySlider.value];
    [self saveToCache];

}

- (IBAction)setAsDefaultTask:(id)sender {
    
    [[NSUserDefaults standardUserDefaults]setObject:self.titleTextField.text forKey:titleKey];
    [[NSUserDefaults standardUserDefaults]setObject:self.descTextView.text forKey:descKey];
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithFloat: self.prioritySlider.value] forKey:priorityKey];
    [[NSUserDefaults standardUserDefaults]setObject:self.itemDatePicker.date forKey:dateKey];

}

- (IBAction)datePickerValueDidChange:(UIDatePicker *)sender {
    
    NSString *theDate = [dateFormat stringFromDate:sender.date];
    self.dateValueLabel.text = [NSString stringWithFormat:@"%@", theDate];
    self.entry.completionDate = sender.date;
    [self saveToCache];
    NSLog(@"%@",sender.date );
    
    
}

- (IBAction)doneAddItem:(id)sender {
    
    if(!([self.titleTextField.text isEqualToString:@""]))
    {
        if(self.isEditing)
        {
            [self updateToDoEntry];
        }
        
        else if(self.displayOnly){
            
        }
        
        else
        {
        ToDo *entry = [[ToDo alloc]init];;
        entry.itemTitle = self.titleTextField.text;
        entry.completionDate = self.itemDatePicker.date;
        entry.itemDesc = self.descTextView.text;
        entry.priority = [NSNumber numberWithFloat: self.prioritySlider.value];
        [self.delegate addItemtoListItemArray:entry];
        }
        
        [self.delegate updateTable];
    }
    
    [self removeFromCache];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)removeFromCache {
    
    NSFileManager *fileManager;
    
    fileManager = [NSFileManager defaultManager];
    
    if ([fileManager removeItemAtPath: filePath error: NULL]  == YES)
        NSLog (@"Remove successful");
    else
        NSLog (@"Remove failed");

    
}

-(void)loadFromCache {
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        ToDo * savedData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (savedData){
            self.entry = savedData;
            self.titleTextField.text = self.entry.itemTitle;
            self.descTextView.text = self.entry.itemDesc;
            self.priorityNumberLabel.text = [NSString stringWithFormat:@" %@", self.entry.priority];
            self.prioritySlider.value = [self.entry.priority floatValue];
            NSString *toDoDate = [dateFormat stringFromDate:self.entry.completionDate];
            self.dateValueLabel.text = toDoDate;
            if(self.entry.completionDate != nil){
            self.itemDatePicker.date = self.entry.completionDate;
            }
            
        }
    }
}

-(void)saveToCache {
    NSLog(@"saved entry %@", self.entry.description);
   [NSKeyedArchiver archiveRootObject:self.entry toFile:filePath];
}

-(void)goBackToMasterView{
    NSLog(@"back to master view");
    //[self removeFromCache];
}

@end
