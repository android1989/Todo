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

@interface CLMTodoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *itemsTableView;
@property (nonatomic, strong) NSMutableArray *items;
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
    self.items = [[[CLMTodoDataManager sharedManager] items] mutableCopy];
    [self.itemsTableView reloadData];
    
    [self skinView];
}

- (void)skinView
{
    [self.itemsTableView setBackgroundColor:[UIColor tealColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
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
    CLMTodoItem *item = [self.items objectAtIndex:indexPath.item];
    cell.titleField.text = item.title;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.item < [self.items count] - 1)
    {
        [tableView switchCellAtIndexPath:indexPath withCellAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item+1 inSection:indexPath.section]];
        [self switchItemAtIndex:indexPath.item withItemAtIndex:indexPath.item+1];
    }
}

#pragma mark - Helpers

- (void)switchItemAtIndex:(NSInteger)indexOne withItemAtIndex:(NSInteger)indexTwo
{
    [self.items exchangeObjectAtIndex:indexOne withObjectAtIndex:indexTwo];
}
@end
