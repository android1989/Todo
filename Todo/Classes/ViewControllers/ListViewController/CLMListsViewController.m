//
//  CLMListsViewController.m
//  Todo
//
//  Created by Andrew Hulsizer on 5/25/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMListsViewController.h"
#import "CLMListCell.h"
#import "CLMTodoList.h"
#import "CLMTodoViewController.h"
#import "CLMTodoDataManager.h"
#import "UIColor+TodoColors.h"

@interface CLMListsViewController () <UITableViewDataSource, UITableViewDelegate, CLMListCellDelegate>

@property (nonatomic, strong) CLMTodoViewController *todoViewController;
@property (nonatomic, strong) IBOutlet UITableView *listsTableView;
@property (nonatomic, strong) NSArray *lists;

@end

@implementation CLMListsViewController

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
    __weak CLMListsViewController *weakSelf = self;
    [[CLMTodoDataManager sharedManager] fetchLists:^(id data) {
        weakSelf.lists = data;
        [weakSelf.listsTableView reloadData];
    }];
    
    [self skinView];
}

- (void)skinView
{
    [self.listsTableView setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:[UIColor creamColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Lazy Loaders

- (CLMTodoViewController *)todoViewController
{
    if (!_todoViewController)
    {
        _todoViewController = [[CLMTodoViewController alloc] init];
    }
    
    return _todoViewController;
}

#pragma mark CLMListCellDelegate
- (void)handleLongPress:(CLMListCell *)cell
{
    int index = 0;
    for (CLMListCell *tempCell in self.listsTableView.visibleCells)
    {
        if (tempCell == cell)
        {
            return;
        }
        [tempCell transitionToDownStateWithDelay:index*.1];
       
        index++;
    }
}

- (void)handleLongPressUp:(CLMListCell *)cell
{
    for (CLMListCell *tempCell in self.listsTableView.visibleCells)
    {
        [tempCell transitionToNormalState];
        if (tempCell == cell)
        {
            return;
        }
        
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.lists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLMListCell *cell = (CLMListCell *)[tableView dequeueReusableCellWithIdentifier:TodoCellIdentifer];
    
    if (!cell)
    {
        cell = [[CLMListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListCellIdentifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    
    //Configure Cell
    CLMTodoList *item = [self.lists objectAtIndex:indexPath.item];
    cell.titleLabel.text = item.title;    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLMListCell *cell = (CLMListCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell transitionToDownStateWithDelay:0];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLMListCell *cell = (CLMListCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell transitionToNormalState];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    /*
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CLMTodoList *list = [self.lists objectAtIndex:indexPath.item];
    self.todoViewController.list = list;
    
    [self addChildViewController:self.todoViewController];
    [self.view addSubview:self.todoViewController.view];
    [self.todoViewController didMoveToParentViewController:self];
     */
}


@end
