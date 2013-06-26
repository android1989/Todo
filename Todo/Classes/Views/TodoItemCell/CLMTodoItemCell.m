//
//  CLMTodoItemCell.m
//  Todo
//
//  Created by Andrew Hulsizer on 5/23/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMTodoItemCell.h"
#import "CLMTodoItem.h"

static const CGFloat kActionThreshold = 50;
static const CGFloat kCenterRestState = 160;
static const CGFloat kLeftThreshold = kCenterRestState + kActionThreshold;
static const CGFloat kRightThreshold = kCenterRestState - kActionThreshold;

@interface CLMTodoItemCell () <UITextFieldDelegate>
@property (nonatomic, assign) ItemCellState state;
@property (nonatomic, weak) IBOutlet UIView *strikeThrough;
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
@end

@implementation CLMTodoItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
        [self.contentView addSubview:view];
        [self setBackgroundColor:[UIColor clearColor]];
        
        [self configureFont];
    }
    return self;
}

- (void)configureFont
{
    [_titleField setFont:[UIFont fontWithName:@"OpenSans-SemiboldItalic" size:14]];
    [_backgroundImageView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    
}

- (NSInteger)cellHeight
{
    return CGRectGetHeight(self.bounds);
}

- (void)configureForItem:(CLMTodoItem *)item
{
    self.titleField.text = item.title;
    
    CGRect titleFieldFrame = self.titleField.frame;
    [self.titleField sizeToFit];
    titleFieldFrame.size.width = CGRectGetWidth(self.titleField.frame);
    self.titleField.frame = titleFieldFrame;

    CGRect strikeThroughFrame = self.strikeThrough.frame;
    if (item.checked)
    {
        _state = CellCheckedState;
        strikeThroughFrame.size.width = titleFieldFrame.size.width;
    }else{
        _state = CellUncheckedState;
        strikeThroughFrame.size.width = 0;
    }
    [self.strikeThrough setFrame:strikeThroughFrame];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)setState:(ItemCellState)state
{
    _state = state;
    switch (_state) {
        case CellCheckedState:
        {
            [self.delegate cellHasBecomeChecked:self];
        }
            break;
        case CellUncheckedState:
        {
            [self.delegate cellHasBecomeUnchecked:self];
        }
            break;
        default:
            break;
    }
}
- (void)switchState
{
    switch (self.state) {
        case CellCheckedState:
        {
            self.state = CellUncheckedState;
        }
            break;
        case CellUncheckedState:
        {
            self.state = CellCheckedState;
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIPanGestureRecognizer

- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)panRecognizer
{
    if(panRecognizer.state == UIGestureRecognizerStateEnded)
    {
        if ((panRecognizer.view.center.x) > kLeftThreshold)
        {
            [self switchState];
        }
        
        if ((panRecognizer.view.center.x) < kRightThreshold)
        {
            [self.delegate cellHasBeenDeleted:self];
        }
        
        //All fingers are lifted.
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.backgroundImageView.center = CGPointMake( kCenterRestState,
                                                          panRecognizer.view.center.y);
            
            CGRect titleFieldFrame = self.titleField.frame;
            titleFieldFrame.origin.x = 20;
            self.titleField.frame = titleFieldFrame;

            
            
            CGRect frame = self.strikeThrough.frame;
            if (self.state == CellUncheckedState)
            {
                frame.size.width = 0*CGRectGetWidth(self.titleField.frame);
            }
            frame.origin.x = CGRectGetMinX(self.titleField.frame);
            [self.strikeThrough setFrame:frame];
        
        } completion:^(BOOL finished) {
            
        }];
        return;
    }else{
        
        CGPoint translation = [panRecognizer translationInView:self.backgroundImageView];
        
        if ((panRecognizer.view.center.x) > kLeftThreshold || (panRecognizer.view.center.x) < kRightThreshold)
        {
            translation.x *= .2;
        }
        
        CGFloat newXPosition = panRecognizer.view.center.x + translation.x;
        
        
        self.backgroundImageView.center = CGPointMake( newXPosition,
                                                      panRecognizer.view.center.y);
        
        CGRect titleFieldFrame = self.titleField.frame;
        titleFieldFrame.origin.x = titleFieldFrame.origin.x+translation.x;
        self.titleField.frame = titleFieldFrame;
        
        CGFloat fraction = MIN(MAX((newXPosition-kCenterRestState)/kActionThreshold,0.0f), 1.0f);
        
        if (self.state == CellCheckedState)
        {
            fraction = 1-fraction;
        }
        
        CGRect frame = self.strikeThrough.frame;
        frame.size.width = fraction*CGRectGetWidth(self.titleField.frame);
        frame.origin.x = CGRectGetMinX(self.titleField.frame);
        [self.strikeThrough setFrame:frame];
        
        [panRecognizer setTranslation:CGPointMake(0, 0) inView:self.backgroundImageView];
    }
    
}

@end
