//
//  AddItemViewController.m
//  ToDoList
//
//  Created by Taylor Ledingham on 2014-10-22.
//  Copyright (c) 2014 Taylor Ledingham. All rights reserved.
//

#import "AddItemViewController.h"

@interface AddItemViewController ()

@end

@implementation AddItemViewController {
    UITapGestureRecognizer *tapRecognizer;
    UITapGestureRecognizer *cellTapRecognizer;
}
    


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - text field delegates

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // do whatever you have to do
    if(textField == self.itemName){
        [textField resignFirstResponder];
        [self.itemDesc becomeFirstResponder];
        
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

- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    [self.view removeGestureRecognizer:tapRecognizer];
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
    
}

-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer {
    [self.itemDesc resignFirstResponder];
    [self.view endEditing:YES];
    

}

#pragma mark - IBActions

- (IBAction)addNewItem:(id)sender {
}

- (IBAction)backToListTableView:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneAddItem:(id)sender {
    
    if(!([self.itemName.text isEqualToString:@""]))
    {
    
    ToDo *newItem = [[ToDo alloc]initWithTitle:self.itemName.text andDesc:self.itemDesc.text andPriority:(int)self.prioritySlider.value];
    
    [self.delegate addItemtoListItemArray:newItem];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];

    
    
    
}
@end
