//
//  CLMTodoItemCell.h
//  Todo
//
//  Created by Andrew Hulsizer on 5/23/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLMTodoItem;

@protocol CLMTodoItemCellDelegate;

typedef NS_ENUM(NSInteger, ItemCellState)
{
    CellCheckedState,
    CellUncheckedState
};

@interface CLMTodoItemCell : UITableViewCell

@property (nonatomic, readonly) ItemCellState state;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) id<CLMTodoItemCellDelegate> delegate;
- (NSInteger)cellHeight;
- (void)configureForItem:(CLMTodoItem *)item;
@end

@protocol CLMTodoItemCellDelegate <NSObject>

- (void)cellHasBeenDeleted:(CLMTodoItemCell *)cell;
- (void)cellHasBecomeChecked:(CLMTodoItemCell *)cell;
- (void)cellHasBecomeUnchecked:(CLMTodoItemCell *)cell;
- (void)cellRequestsEdit:(CLMTodoItemCell *)cell;
@end