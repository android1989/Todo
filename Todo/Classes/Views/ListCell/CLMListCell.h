//
//  CLMListCell.h
//  Todo
//
//  Created by Andrew Hulsizer on 5/25/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CLMListCellDelegate;

@interface CLMListCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIView *mainContentView;
@property (nonatomic, weak) IBOutlet UIView *shadowView;
@property (nonatomic, weak) id<CLMListCellDelegate> delegate;

- (void)transitionToDownStateWithDelay:(CGFloat)delay;
- (void)transitionToNormalState;
@end

@protocol CLMListCellDelegate <NSObject>

- (void)handleLongPress:(CLMListCell *)cell;
- (void)handleLongPressUp:(CLMListCell *)cell;
@end