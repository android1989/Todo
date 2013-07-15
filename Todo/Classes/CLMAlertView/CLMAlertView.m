//
//  CLMAlertView.m
//  Todo
//
//  Created by Andrew Hulsizer on 7/14/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMAlertView.h"

@interface CLMAlertView ()

@property (nonatomic, strong) UIView *customView;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *cancelButtonTitle;
@property (nonatomic, copy) NSArray *otherButtonTitles;
@property (nonatomic, copy) CLMAlertViewShowAnimation showAnimation;
@property (nonatomic, copy) CLMAlertViewDismissAnimation dismissAnimation;

@property (nonatomic, strong) UIButton *alertButton;
@end

@implementation CLMAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super init];
    [self commonInit];
    return self;
}

- (instancetype)initWithView:(UIView *)view delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super init];
    [self commonInit];
    return self;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message selectionBlock:(CLMAlertViewDidSelectItemBlock)selectionBlock cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super init];
    [self commonInit];
    return self;
}

- (instancetype)initWithView:(UIView *)view selectionBlock:(CLMAlertViewDidSelectItemBlock)selectionBlock cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super init];
    [self commonInit];
    return self;
}

- (void)commonInit
{
    [self setAnimationStyle:CLMAlertViewAnimationStyleGrowth];
}

- (void)show
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];

    self.frame = CGRectMake(0, 0, 100, 100);
    self.center = window.center;
    self.backgroundColor = [UIColor darkTextColor];
    [self setClipsToBounds:YES];
    self.
    self.alertButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.alertButton addTarget:self action:@selector(removeAlertView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.alertButton];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    self.showAnimation(self);
}

- (void)removeAlertView
{
    if (self.dismissAnimation)
    {
        self.dismissAnimation(self);
    }else{
        [self.alertButton removeFromSuperview];
    }
}

#pragma mark - Animations
- (void)setAnimationStyle:(CLMAlertViewAnimationStyle)animationStyle
{
    _animationStyle = animationStyle;
    switch (_animationStyle) {
        case CLMAlertViewAnimationStyleGrowth:
            [self setGrowthAnimation];
            break;
        case CLMAlertViewAnimationStyleHorizontal:
            [self setHorizontalAnimation];
            break;
        case CLMAlertViewAnimationStyleVertical:
            [self setVerticalAnimation];
            break;
    }
}

- (void)setCustomShowAnimationBlock:(CLMAlertViewShowAnimation)showAnimationBlock dismissBlock:(CLMAlertViewDismissAnimation)dismissAnimationBlock
{
    self.showAnimation = showAnimationBlock;
    self.dismissAnimation = dismissAnimationBlock;
}

- (void)setGrowthAnimation
{
    [self setShowAnimation:^(CLMAlertView *alertView){
        CGRect oldFrame = alertView.frame;
        alertView.frame = CGRectMake(CGRectGetMidX(oldFrame), CGRectGetMidY(oldFrame), 0, 0);
        [UIView animateWithDuration:1.5 animations:^{
            alertView.frame = oldFrame;
        }];
    }];
    
    [self setDismissAnimation:^(CLMAlertView *alertView){
        CGRect oldFrame = alertView.frame;
        
        [UIView animateWithDuration:1.5 animations:^{
            alertView.frame = CGRectMake(CGRectGetMidX(oldFrame), CGRectGetMidY(oldFrame), 0, 0);
        } completion:^(BOOL finished) {
            [alertView removeFromSuperview];
        }];
    }];
}

- (void)setVerticalAnimation
{
    [self setShowAnimation:^(CLMAlertView *alertView){
        CGRect endFrame = alertView.frame;
        CGRect startFrame = alertView.frame;
        startFrame.origin.y = -startFrame.size.height;
        alertView.frame = startFrame;
        [UIView animateWithDuration:1.5 animations:^{
            alertView.frame = endFrame;
        }];
    }];
    
    [self setDismissAnimation:^(CLMAlertView *alertView){
        CGRect endFrame = alertView.frame;
        CGRect startFrame = alertView.frame;
        endFrame.origin.y = CGRectGetHeight(alertView.superview.frame)+startFrame.size.height;

        [UIView animateWithDuration:1.5 animations:^{
            alertView.frame = endFrame;
        } completion:^(BOOL finished) {
            [alertView removeFromSuperview];
        }];
    }];
}

- (void)setHorizontalAnimation
{
    [self setShowAnimation:^(CLMAlertView *alertView){
        CGRect endFrame = alertView.frame;
        CGRect startFrame = alertView.frame;
        startFrame.origin.x = -startFrame.size.width;
        alertView.frame = startFrame;
        [UIView animateWithDuration:1.5 animations:^{
            alertView.frame = endFrame;
        }];
    }];
    
    [self setDismissAnimation:^(CLMAlertView *alertView){
        CGRect endFrame = alertView.frame;
        CGRect startFrame = alertView.frame;
        endFrame.origin.x = CGRectGetWidth(alertView.superview.frame)+startFrame.size.width;
        
        [UIView animateWithDuration:1.5 animations:^{
            alertView.frame = endFrame;
        } completion:^(BOOL finished) {
            [alertView removeFromSuperview];
        }];
    }];

}


@end
