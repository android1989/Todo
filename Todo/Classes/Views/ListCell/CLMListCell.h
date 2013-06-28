//
//  CLMListCell.h
//  Todo
//
//  Created by Andrew Hulsizer on 5/25/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CLMListCellDelegate;

typedef NS_ENUM(NSInteger, ListCellState)
{
    ListCellCheckedState,
    ListCellUncheckedState
};

@interface CLMListCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIView *mainContentView;
@property (nonatomic, weak) IBOutlet UIView *shadowView;
@property (nonatomic, weak) id<CLMListCellDelegate> delegate;
@property (nonatomic, assign) ListCellState state;

- (void)transitionToDownStateWithDelay:(CGFloat)delay;
- (void)transitionToNormalState;
@end

@protocol CLMListCellDelegate <NSObject>

- (void)handleLongPress:(CLMListCell *)cell;
- (void)handleLongPressUp:(CLMListCell *)cell;

- (void)cellHasBeenDeleted:(CLMListCell *)cell;
- (void)cellHasBecomeChecked:(CLMListCell *)cell;
- (void)cellHasBecomeUnchecked:(CLMListCell *)cell;;
@end