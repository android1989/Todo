//
//  CLMPinchGestureTableView.m
//  Todo
//
//  Created by Andrew Hulsizer on 6/30/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMPinchGestureTableView.h"
#import "CLMListCell.h"

typedef struct CLMPinchTouches {
    CGPoint upper;
    CGPoint lower;
} CLMPinchTouches;

@interface CLMPinchGestureTableView ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CLMListCell *placeholderCell;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGestureRecognizer;
@property (nonatomic, assign) CLMPinchTouches initalTouches;
@property (nonatomic, assign) NSInteger selectedUpperCellIndex;
@property (nonatomic, assign) NSInteger selectedLowerCellIndex;
@property (nonatomic, assign) BOOL pinchGestureInProgress;
@property (nonatomic, assign) BOOL pinchSuccessful;
@end

@implementation CLMPinchGestureTableView

- (instancetype)initWithTableView:(UITableView *)tableView
{
    self = [super init];
    if (self)
    {
        _tableView = tableView;
        [self configureTableView];
    }
    return self;
}

- (void)configureTableView
{
    self.pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGestureRecognizer:)];
    [self.tableView addGestureRecognizer:self.pinchGestureRecognizer];
}

- (CLMListCell *)placeholderCell
{
    if (!_placeholderCell) {
        _placeholderCell = [[CLMListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListCellIdentifer];
    }
    
    return _placeholderCell;
}

- (void)handlePinchGestureRecognizer:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{    
    switch (pinchGestureRecognizer.state)
    {
        case UIGestureRecognizerStateBegan:
            [self pinchGestureBegan:pinchGestureRecognizer];
            break;
        case UIGestureRecognizerStateChanged:
            [self pinchGestureChanged:pinchGestureRecognizer];
            break;
        case UIGestureRecognizerStateEnded:
            [self pinchGestureEnded:pinchGestureRecognizer];
            break;
        default:
            break;
    }
}

- (void)pinchGestureBegan:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    CLMPinchTouches touches = [self getTouchesFromPinch:pinchGestureRecognizer];
    self.initalTouches = touches;
    
    NSArray *visibleCells = self.tableView.visibleCells;
    self.selectedUpperCellIndex = [self getCellFromPoint:touches.upper];
    self.selectedLowerCellIndex = [self getCellFromPoint:touches.lower];
    
    UITableViewCell *upperCell = visibleCells[self.selectedUpperCellIndex];
    UITableViewCell *lowerCell = visibleCells[self.selectedLowerCellIndex];
    
    if ((self.selectedLowerCellIndex - self.selectedUpperCellIndex) == 1)
    {
        self.pinchGestureInProgress = YES;
        CGPoint origin = CGPointMake(CGRectGetMidX(upperCell.frame), CGRectGetMaxY(upperCell.frame));
        self.placeholderCell.center = origin;
        self.placeholderCell.transform = CGAffineTransformMakeScale(0.5, 0.5);
        self.placeholderCell.alpha = 0.0;
        [self.tableView insertSubview:self.placeholderCell atIndex:0];
    }
}

- (void)pinchGestureChanged:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    if (self.pinchGestureInProgress)
    {
        if ((pinchGestureRecognizer.numberOfTouches < 2))
        {
            [self pinchGestureEnded:pinchGestureRecognizer];
            return;
        }
        CLMPinchTouches touches = [self getTouchesFromPinch:pinchGestureRecognizer];
        
        CGFloat upperDelta = touches.upper.y-self.initalTouches.upper.y;
        CGFloat lowerDelta = self.initalTouches.lower.y - touches.lower.y;
        CGFloat delta = -MIN(0, MIN(upperDelta, lowerDelta));
    
        self.pinchSuccessful = (delta > 45);
        
        NSArray *visibleCells = [self.tableView visibleCells];
        
        for (NSInteger index = 0; index < [visibleCells count]; index++)
        {
            UITableViewCell *cell = visibleCells[index];
            if (index <= self.selectedUpperCellIndex)
            {
                cell.transform = CGAffineTransformMakeTranslation(0, -delta);
            }
            else if (index >= self.selectedLowerCellIndex)
            {
                cell.transform = CGAffineTransformMakeTranslation(0, delta);
            }
        }
        
        CGFloat percentComplete = delta/45.0f;
        
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
        CGFloat scalePercent = MAX(.5, MIN(percentComplete, 1.05));
        self.placeholderCell.transform = CGAffineTransformMakeScale(scalePercent, scalePercent);
        self.placeholderCell.alpha = percentComplete;
    }
}

- (void)pinchGestureEnded:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    if (self.pinchGestureInProgress)
    {
        if (self.pinchSuccessful)
        {
            NSArray *visibleCells = [self.tableView visibleCells];
            NSIndexPath *indexPath = [self.tableView indexPathForCell:visibleCells[self.selectedLowerCellIndex]];
            [self.delegate addNewItemAtIndex:indexPath.row];
            
            [UIView animateWithDuration:0.2f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 NSArray *visibleCells = [self.tableView visibleCells];
                                 
                                 for (NSInteger index = 0; index < [visibleCells count]; index++)
                                 {
                                     UITableViewCell *cell = visibleCells[index];
                                     if (index <= self.selectedUpperCellIndex)
                                     {
                                         cell.transform = CGAffineTransformMakeTranslation(0, -45);
                                     }
                                     else if (index >= self.selectedLowerCellIndex)
                                     {
                                         cell.transform = CGAffineTransformMakeTranslation(0, 45);
                                     }
                                 }
                                 
                                 self.placeholderCell.transform = CGAffineTransformIdentity;
                             }
                             completion:^(BOOL finished){
                                 
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     CGPoint contentOffset = self.tableView.contentOffset;
                                     contentOffset.y += 45;
                                     [self.tableView reloadData];
                                     [self.placeholderCell removeFromSuperview];
                                     [self.tableView setContentOffset:contentOffset animated:NO];
                                     
                                     
                                     if (self.tableView.contentSize.height < self.tableView.frame.size.height)
                                     {
                                         [self.tableView setContentOffset:CGPointZero animated:YES];
                                     }
                                     
                                 });
                             }];
        }else{
            [self.placeholderCell removeFromSuperview];
            [UIView animateWithDuration:0.2f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 NSArray *visibleCells = [self.tableView visibleCells];
                                 
                                 for (UITableViewCell *cell in visibleCells)
                                 {
                                     cell.transform = CGAffineTransformIdentity;
                                 }
                             }
                             completion:^(BOOL finished){
                                 
                             }];

        }
        self.pinchGestureInProgress = NO;
    }
}

- (CLMPinchTouches)getTouchesFromPinch:(UIPinchGestureRecognizer *)gesture
{
    CGPoint point1 = [gesture locationOfTouch:0 inView:self.tableView];
    CGPoint point2 = [gesture locationOfTouch:1 inView:self.tableView];
    
    if (point1.y > point2.y)
    {
        CGPoint temp = point1;
        point1 = point2;
        point2 = temp;
    }
    CLMPinchTouches touches = {point1, point2};;
    return touches;
}

- (void)setSelectedIndexs:(UIView *)upper lower:(UIView *)lower
{
    NSArray *cells = self.tableView.visibleCells;
    NSInteger index = 0;
    for (UITableViewCell *cell in cells)
    {
        if (cell == upper)
        {
            self.selectedUpperCellIndex = index;
        }
        
        else if (cell == lower)
        {
            self.selectedLowerCellIndex = index;
        }
        index++;
    }
    
    NSLog(@"Upper:%d, Lower:%d", self.selectedUpperCellIndex, self.selectedLowerCellIndex);
}

- (NSInteger)getCellFromPoint:(CGPoint)point
{
    NSArray *cells = self.tableView.visibleCells;
    for (NSInteger index = 0; index < [cells count]; index++)
    {
        UIView *cell = cells[index];
        if ([self viewContainsPoint:cell withPoint:point])
        {
            return index;
        }
    }
    return -1;
}

- (BOOL) viewContainsPoint:(UIView*)view withPoint:(CGPoint)point
{
    CGRect frame = view.frame;
    return (frame.origin.y < point.y) && (frame.origin.y +frame.size.height) > point.y;
}

@end
