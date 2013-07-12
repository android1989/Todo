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
#import "CLMEditItemViewController.h"
#import "CLMTodoList.h"
#import "CLMListNavigationViewController.h"
#import "CLMTodoItemCell.h"

static const float kPullActionContentOffset = -50.0f;

@interface CLMTodoViewController () <UITableViewDataSource, UITableViewDelegate, CLMEditItemViewControllerDelegate, CLMTodoItemCellDelegate>

@property (nonatomic, strong) CLMEditItemViewController *editViewController;
@property (nonatomic, assign) CGPoint savedContentOffset;

//Scroll View Add Item
@property (nonatomic, assign) BOOL pullInProgress;
@property (nonatomic, assign) BOOL pullComplete;
@property (nonatomic, strong) CLMTodoItemCell *placeholderCell;

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
    [self.tableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
    [self skinView];
}

- (void)viewWillAppear:(BOOL)animated
{
    //Not sure if I actually need to refresh
//    __weak CLMTodoViewController *weakSelf = self;
//    [[CLMTodoDataManager sharedManager] fetchList:self.list completionBlock:^(id data) {
//        weakSelf.list = data;
//        [weakSelf.tableView reloadData];
//    }];
    
    [self.tableView reloadData];
}

- (void)skinView
{
    [self.tableView setBackgroundColor:[UIColor clearColor]];
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

- (CLMTodoItemCell *)placeholderCell
{
    if (!_placeholderCell) {
        _placeholderCell = [[CLMTodoItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TodoCellIdentifer];
        _placeholderCell.center = CGPointMake(_placeholderCell.center.x-1,_placeholderCell.center.y);
    }
    
    return _placeholderCell;
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
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //Configure Cell
    CLMTodoItem *item = [self.list.items objectAtIndex:indexPath.item];
    cell.titleLabel.text = item.title;
        
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    if (indexPath.item < [self.items count] - 1)
//    {
//        [tableView switchCellAtIndexPath:indexPath withCellAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item+1 inSection:indexPath.section]];
//        [self switchItemAtIndex:indexPath.item withItemAtIndex:indexPath.item+1];
//    }
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
                CLMTodoItem *cell = [[CLMTodoItem alloc] init];
                cell.title = @"New Item";
                if (!self.list.items)
                {
                    self.list.items = [[NSMutableArray alloc] init];
                }
                [self.list.items insertObject:cell atIndex:0];
                
                CGPoint contentOffset = self.tableView.contentOffset;
                contentOffset.y += 72;
                [self.tableView reloadData];
                scrollView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
                //[scrollView setContentOffset:CGPointMake(0, -self.tableView.contentInset.top) animated:NO];
                [self.placeholderCell removeFromSuperview];
                
//                [self cellRequestsEdit:self.tableView.visibleCells[0]];
//                self.savedContentOffset = CGPointMake(0, -20);
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

#pragma mark - Helpers

//#pragma mark - CLMTodoItemCellDelegate
//-(void)cellHasBecomeUnchecked:(CLMTodoItemCell *)cell
//{
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//    CLMTodoItem *item = [self.list.items objectAtIndex:indexPath.item];
//    [item updateChecked:NO];
//}
//
//- (void)cellHasBecomeChecked:(CLMTodoItemCell *)cell
//{
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//    CLMTodoItem *item = [self.list.items objectAtIndex:indexPath.item];
//    [item updateChecked:YES];
//}
//
//- (void)cellHasBeenDeleted:(CLMTodoItemCell *)cell
//{
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//    CLMTodoItem *item = [self.list.items objectAtIndex:indexPath.item];
//    [self.list removeTodoItem:item];
//    [self.tableView reloadData];
//}

#pragma mark - CLMEditItemViewControllerDelegate

- (void)editDidFinish
{
    [self.tableView reloadData];
    [UIView animateWithDuration:.5 animations:^{
        self.editViewController.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self.editViewController willMoveToParentViewController:nil];
        [self.editViewController.view removeFromSuperview];
        [self.editViewController removeFromParentViewController];
        self.editViewController.view.alpha = 1.0;
        
        [UIView animateWithDuration:.5 animations:^{
            self.tableView.contentOffset = self.savedContentOffset;
        } completion:^(BOOL finished) {
          
        }];
    }];
}

#pragma mark - CLMTodoItemCellDelegate
- (void)cellRequestsEdit:(CLMTodoItemCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    CLMTodoItem *item = [self.list.items objectAtIndex:indexPath.item];
    self.editViewController.item = item;
    
        CGFloat yTransform = cell.frame.origin.y;
        [UIView animateWithDuration:.5 animations:^{
            CGPoint contentOffset = self.tableView.contentOffset;
            self.savedContentOffset = contentOffset;
            contentOffset.y += yTransform;
            self.tableView.contentOffset = contentOffset;
        } completion:^(BOOL finished) {
            self.editViewController.view.alpha = 0.0;
            [self addChildViewController:self.editViewController];
            [self.view addSubview:self.editViewController.view];
            [self.editViewController didMoveToParentViewController:self];
            [UIView animateWithDuration:.5 animations:^{
                self.editViewController.view.alpha = 1.0;
            } completion:^(BOOL finished) {
            
            }];
        }];
}

#pragma mark - IBActions
- (IBAction)back:(id)sender
{
    [self.navigationViewController popBaseListViewController];
}

- (IBAction)new:(id)sender
{
    CLMTodoItem *newItem = [[CLMTodoItem alloc] init];
    
    [self.list addTodoItem:newItem];
    [self.tableView reloadData];
    
    self.editViewController.item = newItem;
    
    [self addChildViewController:self.editViewController];
    [self.view addSubview:self.editViewController.view];
    [self.editViewController didMoveToParentViewController:self];
}
@end
