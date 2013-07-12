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
#import "CLMTodoItem.h"
#import "CLMPinchGestureTableView.h"
#import "CLMListNavigationViewController.h"

static const float kPullActionContentOffset = -50.0f;

@interface CLMListsViewController () <UITableViewDataSource, UITableViewDelegate, CLMListCellDelegate, CLMPinchGestureTableViewDelegate>

@property (nonatomic, strong) CLMTodoViewController *todoViewController;
@property (nonatomic, strong) NSMutableArray *lists;

//Scroll View Add Item
@property (nonatomic, assign) BOOL pullInProgress;
@property (nonatomic, assign) BOOL pullComplete;
@property (nonatomic, strong) CLMListCell *placeholderCell;

//Pinch
@property (nonatomic, strong) CLMPinchGestureTableView *pinchGestureDelegate;
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
        [weakSelf.tableView reloadData];
    }];
        
    [self skinView];
    
    self.pinchGestureDelegate = [[CLMPinchGestureTableView alloc] initWithTableView:self.tableView];
    self.pinchGestureDelegate.delegate = self;
}

- (void)skinView
{
    [self.tableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorColor:self.view.backgroundColor];
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

- (CLMListCell *)placeholderCell
{
    if (!_placeholderCell) {
        _placeholderCell = [[CLMListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListCellIdentifer];
        _placeholderCell.center = CGPointMake(_placeholderCell.center.x-1,_placeholderCell.center.y);
    }
    
    return _placeholderCell;
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
    cell.countLabel.text = [NSString stringWithFormat:@"%d",[item.items count]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CLMTodoList *list = [self.lists objectAtIndex:indexPath.item];
    self.todoViewController.list = list;
        
    [self.navigationViewController pushBaseListViewController:self.todoViewController fromIndex:indexPath.row];
}

#pragma mark - UIScrollViewDelegate
//might want to refactor into seperate table view
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.pullInProgress = scrollView.contentOffset.y <= 0;
    
    if (self.pullInProgress)
    {
        [self.tableView insertSubview:self.placeholderCell atIndex:0];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.pullInProgress && !self.pullComplete)
    {
        CGFloat percentComplete = (scrollView.contentOffset.y - kPullActionContentOffset)/kPullActionContentOffset;
        self.placeholderCell.alpha = percentComplete +.5;
        
        CGRect oldFrame = self.placeholderCell.frame;
        oldFrame.origin.y = -CGRectGetHeight(oldFrame);
        self.placeholderCell.frame = oldFrame;
        if (percentComplete > 1)
        {
            self.placeholderCell.titleLabel.text = @"Release for New Item";
        }
        else if (percentComplete > .5)
        {
            self.placeholderCell.titleLabel.text = @"Almost There";
        }else{
            self.placeholderCell.titleLabel.text = @"New Item";
        }
    }
    else
    {
        self.pullInProgress = scrollView.contentOffset.y <= 0;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.pullInProgress)
    {
        if (self.pullComplete)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                CLMTodoList *cell = [[CLMTodoList alloc] init];
                cell.title = @"New Item";
                [self.lists insertObject:cell atIndex:0];
                [self.tableView reloadData];
                scrollView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
                [self.placeholderCell removeFromSuperview];
                self.pullComplete = NO;
            });
            self.pullInProgress = NO;
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.pullInProgress)
    {
        CGFloat percentComplete = (scrollView.contentOffset.y - kPullActionContentOffset)/kPullActionContentOffset;
        
        if (percentComplete > 1)
        {
            self.pullComplete = YES;
            self.placeholderCell.titleLabel.text = @"New Item";
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.1];
            scrollView.contentInset = UIEdgeInsetsMake(92.0f, 0.0f, 0.0f, 0.0f);
            [UIView commitAnimations];
            
        }
    }
}

-(void)cellHasBeenDeleted:(CLMListCell *)cell
{
	NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
	[self.lists removeObjectAtIndex:indexPath.row];
	
	[self.tableView beginUpdates];
	[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
	[self.tableView endUpdates];
}

- (void)addNewItemAtIndex:(NSInteger)index
{
    CLMTodoList *cell = [[CLMTodoList alloc] init];
    cell.title = @"New Item";
    [self.lists insertObject:cell atIndex:index];
}
@end
