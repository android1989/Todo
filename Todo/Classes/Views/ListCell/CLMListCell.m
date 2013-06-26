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

@interface CLMListCell () 
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, weak) IBOutlet UIView *cellView;
@property (nonatomic, weak) IBOutlet UIImageView *trashCanImageView;
@property (nonatomic, weak) IBOutlet UIImageView *checkmarkImageView;
@end

@implementation CLMListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
        [self.contentView addSubview:view];
        [self setBackgroundColor:[UIColor clearColor]];
        [self configureFont];
        [self configureGestureRecognizer];
        [self configureShadow];
    }
    return self;
}

- (void)configureGestureRecognizer
{
    //UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    //[self addGestureRecognizer:longPressGestureRecognizer];
    
    [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)]];
}

- (void)configureFont
{
    //[_titleLabel setFont:[UIFont fontWithName:@"OpenSans-SemiboldItalic" size:14]];
}

- (void)configureShadow
{
    CGPathRef path = [UIBezierPath bezierPathWithRect:self.cellView.frame].CGPath;
    [self.cellView.layer setShadowPath:path];
    
    self.cellView.layer.masksToBounds = NO;
    self.cellView.layer.shouldRasterize = YES;
    self.cellView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.cellView.layer.shadowOffset = CGSizeMake(0, 0);
    self.cellView.layer.shadowRadius = 10;
    // Don't forget the rasterization scale
    // I spent days trying to figure out why retina display assets weren't working as expected
    self.cellView.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)layoutSubviews
{
    [self configureShadow];
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

#pragma mark - UIPanGestureRecognizer

- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)panRecognizer
{
    if(panRecognizer.state == UIGestureRecognizerStateEnded)
    {
        //All fingers are lifted.
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.cellView.center = CGPointMake( kCenterRestState,
                                                          self.cellView.center.y);
            self.trashCanImageView.transform = CGAffineTransformMakeScale(0, 0);
            self.checkmarkImageView.transform = CGAffineTransformMakeScale(0, 0);
        } completion:^(BOOL finished) {
            
        }];

        return;
    }else{
        
        CGPoint translation = [panRecognizer translationInView:self.cellView];
        
        if ((self.cellView.center.x) > kLeftThreshold || (self.cellView.center.x) < kRightThreshold)
        {
            translation.x *= .2;
        }
        
        CGFloat newXPosition = self.cellView.center.x + translation.x;
        
        
        self.cellView.center = CGPointMake( newXPosition,
                                            self.cellView.center.y);
        
        CGFloat fraction = MIN(MAX(abs(newXPosition-kCenterRestState)/kActionThreshold,0.0f), 1.0f);
        
        self.trashCanImageView.transform = CGAffineTransformMakeScale(fraction, fraction);
        self.checkmarkImageView.transform = CGAffineTransformMakeScale(fraction, fraction);
        
        [panRecognizer setTranslation:CGPointMake(0, 0) inView:self];
    }
    
}
@end
