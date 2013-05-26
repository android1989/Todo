//
//  CLMEditItemViewController.m
//  Todo
//
//  Created by Andrew Hulsizer on 5/25/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMEditItemViewController.h"
#import "CLMTodoItem.h"

@interface CLMEditItemViewController () <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITextField *titleField;
@end

@implementation CLMEditItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.titleField.text = self.item.title;
    [self.titleField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"])
    {
        [self removeViewController];
        return NO;
    }
    
    return YES;
}

- (IBAction)backgroundTouchedUpInside:(id)sender
{
    [self removeViewController];
}

- (void)removeViewController
{
    [self.titleField resignFirstResponder];
    [self.item updateTitle:self.titleField.text];
    [self.delegate editDidFinish];
}

@end
