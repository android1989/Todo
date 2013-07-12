//
//  CLMTodoItemCell.m
//  Todo
//
//  Created by Andrew Hulsizer on 5/23/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMTodoItemCell.h"
#import "CLMTodoItem.h"

#import "CLMListCell.h"

static const CGFloat kActionThreshold = 100;
static const CGFloat kCenterRestState = 160;
static const CGFloat kLeftThreshold = kCenterRestState + kActionThreshold;
static const CGFloat kRightThreshold = kCenterRestState - kActionThreshold;

@interface CLMTodoItemCell () <UITextFieldDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, weak) IBOutlet UIView *cellView;
@property (nonatomic, assign) ItemCellState state;
@property (nonatomic, weak) IBOutlet UIView *strikeThrough;
@property (nonatomic, weak) IBOutlet UIView *colorTag;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@end

@implementation CLMTodoItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CLMTodoItemCell class]) owner:self options:nil] lastObject];
        [self.contentView addSubview:view];
        self.frame = view.frame;
        [self setBackgroundColor:[UIColor clearColor]];
        
        [self configureFont];
        [self configureTapGestureRecognizer];
        [self configurePanGestureRecognizer];
    }
    return self;
}

- (void)configureFont
{
    
}

- (void)configureTapGestureRecognizer
{
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
    self.tapGestureRecognizer.numberOfTapsRequired = 2;
    [self addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)configurePanGestureRecognizer
{
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
    self.panGestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.panGestureRecognizer];
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
    self.titleLabel.text = item.title;
    
    CGRect titleFieldFrame = self.titleLabel.frame;
    [self.titleLabel sizeToFit];
    titleFieldFrame.size.width = CGRectGetWidth(self.titleLabel.frame);
    self.titleLabel.frame = titleFieldFrame;

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

#pragma mark - UITapGestureRecognizer

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.delegate cellRequestsEdit:self];
}
#pragma mark - UIPanGestureRecognizer

-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:self];
    
    // Check for horizontal gesture
    if (fabsf(translation.x) > fabsf(translation.y))
    {
        return YES;
    }
    
    return NO;
}


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
            self.cellView.center = CGPointMake(kCenterRestState,
                                                self.cellView.center.y);
        } completion:^(BOOL finished) {

        }];
        return;
    }else{

        CGPoint translation = [panRecognizer translationInView:self];

        if ((self.cellView.center.x) > kLeftThreshold || (self.cellView.center.x) < kRightThreshold || (self.cellView.center.x) > kCenterRestState)
        {
            translation.x *= .2;
        }
        CGFloat newXPosition = self.cellView.center.x + translation.x;
        CGFloat fraction = MIN(MAX(abs(newXPosition-kCenterRestState)/kActionThreshold,0.0f), 1.0f);
        //self.backgroundColor = [UIColor colorWithRed:127.0f/255.0f green:236.0f/255.0f blue:93.0f/255.0f alpha:fraction];

        CGPoint newCenter = CGPointMake( newXPosition,
                                  self.cellView.center.y);
        
        
        self.cellView.center = newCenter;
       
        [panRecognizer setTranslation:CGPointMake(0, 0) inView:self.cellView];
    }
}


//- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)panRecognizer
//{
//    if(panRecognizer.state == UIGestureRecognizerStateEnded)
//    {
//        if ((panRecognizer.view.center.x) > kLeftThreshold)
//        {
//            [self switchState];
//        }
//        
//        if ((panRecognizer.view.center.x) < kRightThreshold)
//        {
//            [self.delegate cellHasBeenDeleted:self];
//        }
//        
//        //All fingers are lifted.
//        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            self.backgroundImageView.center = CGPointMake( kCenterRestState,
//                                                          panRecognizer.view.center.y);
//            
//            CGRect titleFieldFrame = self.titleField.frame;
//            titleFieldFrame.origin.x = 20;
//            self.titleField.frame = titleFieldFrame;
//
//            
//            
//            CGRect frame = self.strikeThrough.frame;
//            if (self.state == CellUncheckedState)
//            {
//                frame.size.width = 0*CGRectGetWidth(self.titleField.frame);
//            }
//            frame.origin.x = CGRectGetMinX(self.titleField.frame);
//            [self.strikeThrough setFrame:frame];
//        
//        } completion:^(BOOL finished) {
//            
//        }];
//        return;
//    }else{
//        
//        CGPoint translation = [panRecognizer translationInView:self.backgroundImageView];
//        
//        if ((panRecognizer.view.center.x) > kLeftThreshold || (panRecognizer.view.center.x) < kRightThreshold)
//        {
//            translation.x *= .2;
//        }
//        
//        CGFloat newXPosition = panRecognizer.view.center.x + translation.x;
//        
//        
//        self.backgroundImageView.center = CGPointMake( newXPosition,
//                                                      panRecognizer.view.center.y);
//        
//        CGRect titleFieldFrame = self.titleField.frame;
//        titleFieldFrame.origin.x = titleFieldFrame.origin.x+translation.x;
//        self.titleField.frame = titleFieldFrame;
//        
//        CGFloat fraction = MIN(MAX((newXPosition-kCenterRestState)/kActionThreshold,0.0f), 1.0f);
//        
//        if (self.state == CellCheckedState)
//        {
//            fraction = 1-fraction;
//        }
//        
//        CGRect frame = self.strikeThrough.frame;
//        frame.size.width = fraction*CGRectGetWidth(self.titleField.frame);
//        frame.origin.x = CGRectGetMinX(self.titleField.frame);
//        [self.strikeThrough setFrame:frame];
//        
//        [panRecognizer setTranslation:CGPointMake(0, 0) inView:self.backgroundImageView];
//    }
//    
//}

@end
