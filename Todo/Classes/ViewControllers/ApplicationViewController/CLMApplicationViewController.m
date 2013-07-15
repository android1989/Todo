//
//  CLMApplicationViewController.m
//  Todo
//
//  Created by Andrew Hulsizer on 5/23/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMApplicationViewController.h"
#import "CLMListsViewController.h"
#import "CLMTodoViewController.h"
#import "CLMMenuViewController.h"
#import "CLMListNavigationViewController.h"

//Testing
#import "CLMAlertView.h"
@interface CLMApplicationViewController ()

@property (nonatomic, strong) CLMAlertView *alertView;
@end

@implementation CLMApplicationViewController

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
	// Do any additional setup after loading the view.
    
    if (self.applicationLaunchBlock)
    {
        self.applicationLaunchBlock();
    }
    
  
    
}

- (void)viewDidAppear:(BOOL)animated
{
    self.alertView = [[CLMAlertView alloc] initWithTitle:@"YAY" message:@"This is a test AlertView" selectionBlock:^(CLMAlertView *alertView, NSInteger buttonIndex)
                               {
                                   //Print the name of the button!
                                   NSLog(@"BUTTON SELECTED");
                               } cancelButtonTitle:nil otherButtonTitles:nil];
    
    [self.alertView show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
