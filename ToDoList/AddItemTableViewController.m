//
//  AddItemTableViewController.m
//  ToDoList
//
//  Created by Taylor Ledingham on 2014-10-24.
//  Copyright (c) 2014 Taylor Ledingham. All rights reserved.
//

#import "AddItemTableViewController.h"

@interface AddItemTableViewController ()

@end

@implementation AddItemTableViewController {
    
    UITapGestureRecognizer *tapRecognizer;
    UITapGestureRecognizer *cellTapRecognizer;
    BOOL isCellExpanded;
    NSDateFormatter *dateFormat;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isCellExpanded = NO;
    self.descTextView.delegate = self;
    self.titleTextField.delegate = self;
    self.itemDatePicker.hidden = YES;
    dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM. dd 'at' hh:mm"];

    
    //[self.tableView registerClass:[UITableViewCell class] forCellWithReuseIdentifier:@"DateCell"];
    
    if(self.entry != nil && self.isEditing == YES){
        [self setTableForEditing];
    }
    else if(self.displayOnly == YES && self.entry != nil){
        [self setTableForDisplayOnly];
    }
    else {
 
    NSDate *currDate = [NSDate date];
    NSString *theDate = [dateFormat stringFromDate:currDate];
    self.dateValueLabel.text = [NSString stringWithFormat:@"%@", theDate];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTableForEditing {
    
    self.titleTextField.text = self.entry.itemTitle;
    self.descTextView.text = self.entry.itemDesc;
    self.priorityNumberLabel.text = [NSString stringWithFormat:@" %.0f", self.entry.priority];
    self.prioritySlider.value = self.entry.priority;
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
    self.entry.priority = self.prioritySlider.value;
    self.entry.completionDate = self.itemDatePicker.date;
    
    TLCoreDataStack *coreDataStack = [TLCoreDataStack defaultStack];
    [coreDataStack saveContext];
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
    
    
    [textField resignFirstResponder];
    
}
//
//- (BOOL)textView:(UITextView *)textView
//shouldChangeTextInRange:(NSRange)range
// replacementText:(NSString *)text
//{
//    if ([text isEqualToString:@"\n"])
//    {
//        [textView resignFirstResponder];
//    }
//    return YES;
//}

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
        //NSIndexPath *datePickerPath = [[NSIndexPath alloc]initWithIndex:<#(NSUInteger)#>;
        
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
}

- (IBAction)datePickerValueDidChange:(UIDatePicker *)sender {
    
    NSString *theDate = [dateFormat stringFromDate:sender.date];
    self.dateValueLabel.text = [NSString stringWithFormat:@"%@", theDate];
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
        TLCoreDataStack *coreDataStack = [TLCoreDataStack defaultStack];
        ToDo *entry = [NSEntityDescription insertNewObjectForEntityForName:@"ToDo" inManagedObjectContext:coreDataStack.managedObjectContext];
        entry.itemTitle = self.titleTextField.text;
        entry.completionDate = self.itemDatePicker.date;
        entry.itemDesc = self.descTextView.text;
        entry.priority = self.prioritySlider.value;
        [coreDataStack saveContext];
        }
        
        [self.delegate updateTable];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
