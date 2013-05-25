//
//  CLMTodoViewController.m
//  Todo
//
//  Created by Andrew Hulsizer on 5/23/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMTodoViewController.h"
#import "CLMTodoDataManager.h"
#import "CLMTodoItem.h"
#import "UITableView+CellSwitch.h"
#import "UIColor+TodoColors.h"
#import "CLMTodoItemCell.h"
#import "CLMEditItemViewController.h"
#import "CLMTodoList.h"

@interface CLMTodoViewController () <UITableViewDataSource, UITableViewDelegate, CLMEditItemViewControllerDelegate>

@property (nonatomic, strong) CLMEditItemViewController *editViewController;
@property (nonatomic, strong) IBOutlet UITableView *itemsTableView;
@end

@implementation CLMTodoViewController

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

    [self skinView];
}

- (void)viewWillAppear:(BOOL)animated
{
    //Not sure if I actually need to refresh
//    __weak CLMTodoViewController *weakSelf = self;
//    [[CLMTodoDataManager sharedManager] fetchList:self.list completionBlock:^(id data) {
//        weakSelf.list = data;
//        [weakSelf.itemsTableView reloadData];
//    }];
    
    [self.itemsTableView reloadData];
}

- (void)skinView
{
    [self.view setBackgroundColor:[UIColor fireColor]];
    [self.itemsTableView setBackgroundColor:[UIColor clearColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Lazy Loaders

- (CLMEditItemViewController *)editViewController
{
    if (!_editViewController)
    {
        _editViewController = [[CLMEditItemViewController alloc] init];
        _editViewController.delegate = self;
    }
    
    return _editViewController;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.list.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLMTodoItemCell *cell = (CLMTodoItemCell *)[tableView dequeueReusableCellWithIdentifier:TodoCellIdentifer];
    
    if (!cell)
    {
        cell = [[CLMTodoItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TodoCellIdentifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //Configure Cell
    CLMTodoItem *item = [self.list.items objectAtIndex:indexPath.item];
    cell.titleField.text = item.title;
    
    
    CGRect titleFieldFrame = cell.titleField.frame;
    [cell.titleField sizeToFit];
    titleFieldFrame.size.width = CGRectGetWidth(cell.titleField.frame);
    cell.titleField.frame = titleFieldFrame;

    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CLMTodoItem *item = [self.list.items objectAtIndex:indexPath.item];
    self.editViewController.item = item;
    
    [self addChildViewController:self.editViewController];
    [self.view addSubview:self.editViewController.view];
    [self.editViewController didMoveToParentViewController:self];
//    if (indexPath.item < [self.items count] - 1)
//    {
//        [tableView switchCellAtIndexPath:indexPath withCellAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item+1 inSection:indexPath.section]];
//        [self switchItemAtIndex:indexPath.item withItemAtIndex:indexPath.item+1];
//    }
}

#pragma mark - Helpers

#pragma mark - CLMEditItemViewControllerDelegate

- (void)editDidFinish
{
    [self.editViewController willMoveToParentViewController:nil];
    [self.editViewController.view removeFromSuperview];
    [self.editViewController removeFromParentViewController];
    
    [self.itemsTableView reloadData];
}

#pragma mark - IBActions
- (IBAction)back:(id)sender
{
    [self willMoveToParentViewController:nil];
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
}

- (IBAction)new:(id)sender
{
    CLMTodoItem *newItem = [[CLMTodoItem alloc] init];
    newItem.title = @"THIS IS A TEST PART 3";
    
    [self.list addTodoItem:newItem];
    [self.itemsTableView reloadData];
}
@end
