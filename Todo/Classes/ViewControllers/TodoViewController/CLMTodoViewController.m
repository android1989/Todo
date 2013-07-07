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
#import "CLMListCell.h"
#import "CLMEditItemViewController.h"
#import "CLMTodoList.h"

static const float kPullActionContentOffset = -50.0f;

@interface CLMTodoViewController () <UITableViewDataSource, UITableViewDelegate, CLMEditItemViewControllerDelegate>

@property (nonatomic, strong) CLMEditItemViewController *editViewController;
@property (nonatomic, strong) IBOutlet UITableView *itemsTableView;

//Scroll View Add Item
@property (nonatomic, assign) BOOL pullInProgress;
@property (nonatomic, strong) CLMListCell *placeholderCell;

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

- (CLMListCell *)placeholderCell
{
    if (!_placeholderCell) {
        _placeholderCell = [[CLMListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListCellIdentifer];
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
    CLMListCell *cell = (CLMListCell *)[tableView dequeueReusableCellWithIdentifier:ListCellIdentifer];
    
    if (!cell)
    {
        cell = [[CLMListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListCellIdentifer];
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

#pragma mark - UIScrollViewDelegate
//might want to refactor into seperate table view
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.pullInProgress = scrollView.contentOffset.y <= 0;
    
    if (self.pullInProgress)
    {
        [self.itemsTableView insertSubview:self.placeholderCell atIndex:0];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.pullInProgress)
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
        
        CGFloat percentComplete = (scrollView.contentOffset.y - kPullActionContentOffset)/kPullActionContentOffset;
        
        if (percentComplete > 1)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                CLMTodoItem *cell = [[CLMTodoItem alloc] init];
                cell.title = @"New Item";
                [self.list.items insertObject:cell atIndex:0];
                
                CGPoint contentOffset = self.itemsTableView.contentOffset;
                contentOffset.y += 90;
                [self.itemsTableView reloadData];
                [self.itemsTableView setContentOffset:contentOffset animated:NO];
                [self.itemsTableView setContentOffset:CGPointZero animated:YES];
                [self.placeholderCell removeFromSuperview];
            });
            self.pullInProgress = NO;
        }
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (self.pullInProgress)
    {
        
        CGFloat percentComplete = (scrollView.contentOffset.y - kPullActionContentOffset)/kPullActionContentOffset;
        
        if (percentComplete > 1)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [scrollView setContentOffset:CGPointMake(0, -90) animated:YES];
            });
            return;
        }
    }
}

#pragma mark - Helpers

//#pragma mark - CLMTodoItemCellDelegate
//-(void)cellHasBecomeUnchecked:(CLMTodoItemCell *)cell
//{
//    NSIndexPath *indexPath = [self.itemsTableView indexPathForCell:cell];
//    CLMTodoItem *item = [self.list.items objectAtIndex:indexPath.item];
//    [item updateChecked:NO];
//}
//
//- (void)cellHasBecomeChecked:(CLMTodoItemCell *)cell
//{
//    NSIndexPath *indexPath = [self.itemsTableView indexPathForCell:cell];
//    CLMTodoItem *item = [self.list.items objectAtIndex:indexPath.item];
//    [item updateChecked:YES];
//}
//
//- (void)cellHasBeenDeleted:(CLMTodoItemCell *)cell
//{
//    NSIndexPath *indexPath = [self.itemsTableView indexPathForCell:cell];
//    CLMTodoItem *item = [self.list.items objectAtIndex:indexPath.item];
//    [self.list removeTodoItem:item];
//    [self.itemsTableView reloadData];
//}

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
    
    [self.list addTodoItem:newItem];
    [self.itemsTableView reloadData];
    
    self.editViewController.item = newItem;
    
    [self addChildViewController:self.editViewController];
    [self.view addSubview:self.editViewController.view];
    [self.editViewController didMoveToParentViewController:self];
}
@end
