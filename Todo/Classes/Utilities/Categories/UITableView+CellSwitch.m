//
//  UITableView+CellSwitch.m
//  Todo
//
//  Created by Andrew Hulsizer on 5/23/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "UITableView+CellSwitch.h"
#import "UIView+ImageCapture.h"

@implementation UITableView (CellSwitch)

- (void)switchCellAtIndexPath:(NSIndexPath *)firstCellIndexPath withCellAtIndexPath:(NSIndexPath *)secondCellIndexPath
{
    UITableViewCell *firstCell = [self cellForRowAtIndexPath:firstCellIndexPath];
    UITableViewCell *secondCell = [self cellForRowAtIndexPath:secondCellIndexPath];
    
    [firstCell setBackgroundColor:[UIColor clearColor]];
    [secondCell setBackgroundColor:[UIColor clearColor]];
    
    CGRect firstFrame = [firstCell frame];
    CGRect secondFrame = [secondCell frame];
        
    __weak UITableView *weakSelf = self;
    self.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        secondCell.frame = firstFrame;
        firstCell.frame = secondFrame;
    } completion:^(BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.userInteractionEnabled = YES;
            [weakSelf reloadData];
        });
    }];
}
@end
