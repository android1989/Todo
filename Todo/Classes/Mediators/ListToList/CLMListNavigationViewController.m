//
//  CLMListToItemsMediator.m
//  Todo
//
//  Created by Andrew Hulsizer on 7/8/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMListNavigationViewController.h"
#import "CLMListsViewController.h"
#import "CLMTodoViewController.h"
#import "CLMListCell.h"

typedef void(^CLMNavigationCompletionBlock)(void);

static const CGFloat kFoldingDelay = .2;

@interface CLMListNavigationViewController ()

@property (nonatomic, strong) NSMutableArray *screenStack;
@property (nonatomic, strong) CLMBaseListViewController *root;

@end
@implementation CLMListNavigationViewController

- (instancetype)initWithRootListViewController:(CLMBaseListViewController *)root
{
    self = [super init];
    if (self)
    {
        [self commonInit];
        _root = root;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _screenStack = [[NSMutableArray alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self pushBaseListViewController:self.root fromIndex:0];
}

- (void)addViewController:(CLMBaseListViewController *)baseListViewController
{
    baseListViewController.navigationViewController = self;
    [self.screenStack addObject:baseListViewController];
    
    [self addChildViewController:baseListViewController];
    [self.view addSubview:baseListViewController.view];
    [baseListViewController didMoveToParentViewController:self];
}

- (void)removeViewController:(CLMBaseListViewController *)baseListViewController
{
    [baseListViewController willMoveToParentViewController:nil];
    [baseListViewController removeFromParentViewController];
    [baseListViewController.view removeFromSuperview];
    
    [self.screenStack removeObject:baseListViewController];
}

- (void)pushBaseListViewController:(CLMBaseListViewController *)baseListViewController fromIndex:(NSInteger)index
{
    CLMBaseListViewController *parent = [self.screenStack lastObject];
    [self addViewController:baseListViewController];
    [self.view bringSubviewToFront:baseListViewController.view];
    [self.view bringSubviewToFront:parent.view];
    
    [self transitionToTableView:baseListViewController.tableView fromTableView:parent.tableView selectedIndex:index direction:CLMTransitionDirectionRight completion:^{
        [parent.view removeFromSuperview];
    }];
}

- (void)popBaseListViewControllerByPercentage:(CGFloat)percent
{
    CLMBaseListViewController *child = [self.screenStack lastObject];
    CLMBaseListViewController *parent = [self.screenStack objectAtIndex:[self.screenStack count]-2];
    NSInteger index = [[child.tableView visibleCells] count] / 2.0f;
    
    [self transitionToTableView:child.tableView fromTableView:parent.tableView selectedIndex:index direction:CLMTransitionDirectionRight percentComplete:percent];
}

- (void)popBaseListViewController
{
    if ([self.screenStack count] > 1)
    {
        CLMBaseListViewController *child = [self.screenStack objectAtIndex:[self.screenStack count]-1];
        CLMBaseListViewController *parent = [self.screenStack objectAtIndex:[self.screenStack count]-2];
        
        NSInteger index = [[child.tableView visibleCells] count] / 2.0f;
        [self transitionToTableView:parent.tableView fromTableView:child.tableView selectedIndex:index direction:CLMTransitionDirectionLeft completion:^{
            
            for (UITableViewCell *cell in child.tableView.visibleCells)
            {
                cell.transform = CGAffineTransformIdentity;
            }
            [self removeViewController:child];
        }];
    }
}

#pragma mark - UITableView Animations

- (void)transitionToTableView:(UITableView *)toTableView fromTableView:(UITableView *)fromTableView selectedIndex:(NSInteger)selectedIndex direction:(CLMTransitionDirection)direction completion:(CLMNavigationCompletionBlock)completionBlock
{
    fromTableView.userInteractionEnabled = NO;
    toTableView.userInteractionEnabled = YES;
    NSArray *visibleCells1 = [fromTableView visibleCells];
    NSArray *visibleCells2 = [toTableView visibleCells];
    
    CLMListCell *selectedCell = visibleCells1[selectedIndex];
    
    for (UITableViewCell *cell in visibleCells2)
    {
        CGFloat yTransform = -cell.frame.origin.y;
        cell.alpha = 0.0f;
        cell.transform = CGAffineTransformMakeTranslation(0, yTransform);
    }

    
    [UIView animateWithDuration:.3 animations:^{
        for (UITableViewCell *cell in visibleCells1)
        {
            if (cell == selectedCell)
            {
                selectedCell.titleLabel.alpha = 0.0;
                selectedCell.countLabel.alpha = 0.0;
                continue;
            }
            
            cell.alpha = 0.0f;
        }
    } completion:^(BOOL finished) {
        CGFloat yTransform = -selectedCell.frame.origin.y+fromTableView.contentOffset.y+fromTableView.contentInset.top;
        [UIView animateWithDuration:.5 animations:^{
           selectedCell.transform = CGAffineTransformMakeTranslation(0, yTransform);
            selectedCell.colorTag.frame = CGRectMake(0, 0, 5, 70);
            
        } completion:^(BOOL finished) {
            selectedCell.alpha = 0.0;
            for (UITableViewCell *cell in visibleCells2)
            {
                cell.alpha = 1.0f;
            }
            [UIView animateWithDuration:.5 animations:^{
                for (UITableViewCell *cell in visibleCells2)
                {
                    cell.transform = CGAffineTransformIdentity;
                    cell.alpha = 1.0f;
                }
            } completion:^(BOOL finished) {
                [fromTableView removeFromSuperview];
                fromTableView.userInteractionEnabled = YES;
                toTableView.userInteractionEnabled = YES;
                
                for (UITableViewCell *cell in visibleCells1)
                {
                    cell.transform = CGAffineTransformIdentity;
                    cell.alpha = 1.0;
                }
                
                completionBlock();
            }];
        }];
        
        
    }];
   
}

- (void)transitionToTableView:(UITableView *)toTableView fromTableView:(UITableView *)fromTableView selectedIndex:(NSInteger)selectedIndex direction:(CLMTransitionDirection)direction percentComplete:(CGFloat)percentComplete
{
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    
    NSArray *visibleCells1 = [fromTableView visibleCells];
    NSArray *visibleCells2 = [toTableView visibleCells];
    
    NSInteger count = MAX(visibleCells2.count, visibleCells1.count);
    for (int index = 0; index < count; index++)
    {
        UITableViewCell *cell1 = nil;
        UITableViewCell *cell2 = nil;
        
        if (index < visibleCells1.count)
            cell1 = [visibleCells1 objectAtIndex:index];
        
        if (index < visibleCells2.count)
            cell2 = [visibleCells2 objectAtIndex:index];
        
        if (cell1)
        {
            CGPoint center = cell1.center;
            center.x = (screenWidth*percentComplete)*direction;
            cell1.center = center;
        }
        
        if (cell2)
        {
            CGPoint center = cell2.center;
            center.x = ((screenWidth*percentComplete)*direction)+screenWidth;
            cell2.center = center;
        }
    }
}

@end
