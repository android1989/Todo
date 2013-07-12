//
//  CLMListCell.m
//  Todo
//
//  Created by Andrew Hulsizer on 5/25/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMListCell.h"

static const CGFloat kActionThreshold = 80;
static const CGFloat kCenterRestState = 160;
static const CGFloat kLeftThreshold = kCenterRestState + kActionThreshold;
static const CGFloat kRightThreshold = kCenterRestState - kActionThreshold;

@interface CLMListCell () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@end

@implementation CLMListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
        [self.contentView addSubview:view];
        self.frame = view.frame;
        [self setBackgroundColor:[UIColor clearColor]];
        [self configureFont];
        [self configureGestureRecognizer];
    }
    return self;
}

- (void)configureGestureRecognizer
{
    //UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    //[self addGestureRecognizer:longPressGestureRecognizer];
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
    self.panGestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.panGestureRecognizer];
}

- (void)configureFont
{
    //[_titleLabel setFont:[UIFont fontWithName:@"OpenSans-SemiboldItalic" size:14]];
}


//- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
//{
//    if (recognizer.state == UIGestureRecognizerStateBegan)
//    {
//        [self.delegate handleLongPress:self];
//    }else if (recognizer.state == UIGestureRecognizerStateEnded)
//    {
//        [self.delegate handleLongPressUp:self];
//    }
//
//}
//
//- (void)transitionToDownStateWithDelay:(CGFloat)delay
//{
//    [UIView animateWithDuration:0.05 delay:delay options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//        CGRect frame = self.mainContentView.frame;
//        frame.size.width += 5;
//        frame.size.height += 5;
//        frame.origin.x -= 2;
//        frame.origin.y -= 2;
//        [self.mainContentView setFrame:frame];
//
//        frame.origin.x += 4;
//        frame.origin.y += 4;
//        [self.shadowView setFrame:frame];
//    } completion:^(BOOL finished) {
//        
//    }];
//}
//
//- (void)transitionToNormalState
//{
//    [UIView animateWithDuration:.05 animations:^{
//        CGRect frame = self.mainContentView.frame;
//        frame.size.width -= 5;
//        frame.size.height -= 5;
//        frame.origin.x += 2;
//        frame.origin.y += 2;
//        [self.mainContentView setFrame:frame];
//        [self.shadowView setFrame:frame];
//    }];
//}

- (void)animateDeletion
{

	//All fingers are lifted.
	[UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			
        } completion:^(BOOL finished) {
			[self.delegate cellHasBeenDeleted:self];
		}];
	}];

	
}

- (void)animateCheck
{
    //All fingers are lifted.
	[UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    } completion:^(BOOL finished) {
       
	}];
    
	
}
#pragma mark - UIPanGestureRecognizer

- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)panRecognizer
{
    if(panRecognizer.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.center = CGPointMake(kCenterRestState,
                                               self.center.y);
        } completion:^(BOOL finished) {
            
        }];

        return;
    }else{
        
        CGPoint translation = [panRecognizer translationInView:self];
        
        if ((self.center.x) > kLeftThreshold || (self.center.x) < kRightThreshold)
        {
            translation.x *= .2;
        }
        
        CGFloat newXPosition = self.center.x + translation.x;
        
        
        self.center = CGPointMake( newXPosition,
                                            self.center.y);
        
        CGFloat fraction = MIN(MAX(abs(newXPosition-kCenterRestState)/kActionThreshold,0.0f), 1.0f);
        
        [panRecognizer setTranslation:CGPointMake(0, 0) inView:self];
    }
    
}

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

@end
