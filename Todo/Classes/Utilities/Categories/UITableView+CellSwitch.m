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
    
    CGRect firstFrame = [firstCell frame];
    CGRect secondFrame = [secondCell frame];
    
    UIImageView *firstImageView = [[UIImageView alloc] initWithImage:[firstCell imageFromView]];
    UIImageView *secondImageView = [[UIImageView alloc] initWithImage:[secondCell imageFromView]];
    
    firstImageView.frame = firstFrame;
    secondImageView.frame = secondFrame;
    
    //Append the views;
    [self addSubview:firstImageView];
    [self addSubview:secondImageView];
    
    //make cells invisible
    firstCell.alpha = 0.0;
    secondCell.alpha = 0.0;
    
    __weak UITableView *weakSelf = self;
    self.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        secondImageView.frame = firstFrame;
        firstImageView.frame = secondFrame;
    } completion:^(BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.userInteractionEnabled = YES;
            [weakSelf reloadData];
            [firstImageView removeFromSuperview];
            [secondImageView removeFromSuperview];
        });
    }];
}
@end
