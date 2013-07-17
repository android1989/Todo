//
//  CLMAlertView.m
//  Todo
//
//  Created by Andrew Hulsizer on 7/14/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMAlertView.h"

static const CGFloat kCLMAlertViewPadding = 10.0f;
static const CGFloat kCLMAlertViewDefaultButtonHeight = 44.0f;
static const CGFloat kCLMAlertViewMinimumHeight = 140.0f;
static const CGFloat kCLMAlertViewWidth = 240.0f;
@interface CLMAlertView ()

@property (nonatomic, strong) UIView *customView;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSArray *buttonTitles;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, copy) CLMAlertViewShowAnimation showAnimation;
@property (nonatomic, copy) CLMAlertViewDismissAnimation dismissAnimation;
@property (nonatomic, copy) CLMAlertViewDidSelectItemBlock selectionBlock;
@property (nonatomic, strong) UIButton *cancelButton;
@end

@implementation CLMAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate buttonTitles:(NSArray *)buttonTitles
{
    self = [super init];
    if (self)
    {
        _title = title;
        _message = message;
        _delegate = delegate;
        _buttonTitles = [buttonTitles copy];
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithView:(UIView *)view delegate:(id)delegate buttonTitles:(NSArray *)buttonTitles
{
    self = [super init];
    if (self)
    {
        _customView = view;
        _delegate = delegate;
        _buttonTitles = [buttonTitles copy];
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles selectionBlock:(CLMAlertViewDidSelectItemBlock)selectionBlock
{
    self = [super init];
    if (self)
    {
        _title = title;
        _message = message;
        _selectionBlock = selectionBlock;
        _buttonTitles = [buttonTitles copy];
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithView:(UIView *)view buttonTitles:(NSArray *)buttonTitles selectionBlock:(CLMAlertViewDidSelectItemBlock)selectionBlock
{
    self = [super init];
    if (self)
    {
        _customView = view;
        _selectionBlock = selectionBlock;
        _buttonTitles = [buttonTitles copy];
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    [self setAnimationStyle:CLMAlertViewAnimationStyleGrowth];
    self.buttons = [[NSMutableArray alloc] init];
    [self buildView];
}

- (void)buildView
{
    if (self.customView)
    {
        CGRect frame = CGRectInset(self.customView.frame, -kCLMAlertViewPadding, -kCLMAlertViewPadding);
        UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, kCLMAlertViewDefaultButtonHeight)];
        frame.size.height += CGRectGetHeight(cancel.frame);
        self.frame = frame;
        [self addSubview:self.customView];
        [self addSubview:cancel];
    }else{
        UIFont *titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        NSDictionary *titleAttrsDictionary = [NSDictionary dictionaryWithObject:titleFont
                                                                    forKey:NSFontAttributeName];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                    forKey:NSFontAttributeName];
        
        CGRect titleSize = [_title boundingRectWithSize:CGSizeMake(kCLMAlertViewWidth, kCLMAlertViewMinimumHeight) options:NSStringDrawingUsesDeviceMetrics attributes:titleAttrsDictionary context:(__bridge NSStringDrawingContext *)(UIGraphicsGetCurrentContext())];
        titleSize.origin.y += kCLMAlertViewPadding;
        
        CGRect messageSize = [_message boundingRectWithSize:CGSizeMake(kCLMAlertViewWidth, kCLMAlertViewMinimumHeight) options:NSStringDrawingUsesDeviceMetrics attributes:attrsDictionary context:(__bridge NSStringDrawingContext *)(UIGraphicsGetCurrentContext())];
        messageSize.origin.y  = CGRectGetMaxX(titleSize)+kCLMAlertViewPadding;
        messageSize.size.width = kCLMAlertViewWidth-(kCLMAlertViewPadding*2);
        titleSize.size.width = kCLMAlertViewWidth-(kCLMAlertViewPadding*2);
        
        CGFloat maxHeight = MAX(titleSize.size.height+messageSize.size.height, kCLMAlertViewMinimumHeight);
        CGRect frame = CGRectMake(0, 0, kCLMAlertViewWidth, maxHeight);
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleSize];
        titleLabel.text = _title;
        titleLabel.font = titleFont;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:messageSize];
        messageLabel.text = _message;
        messageLabel.font = font;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:titleLabel];
        [self addSubview:messageLabel];
        
        CGFloat runningX = kCLMAlertViewPadding;
        for (NSString *newTitle in self.buttonTitles)
        {
            UIButton *newButton = [self buttonWithTitle:newTitle];
            newButton.frame = CGRectMake(runningX, frame.size.height, (((frame.size.width-(kCLMAlertViewPadding*2))-((self.buttonTitles.count-1)*kCLMAlertViewPadding))/self.buttonTitles.count), kCLMAlertViewDefaultButtonHeight);
            runningX += (((frame.size.width-(kCLMAlertViewPadding*2))-((self.buttonTitles.count-1)*kCLMAlertViewPadding))/self.buttonTitles.count)+kCLMAlertViewPadding;
            
            [self.buttons addObject:newButton];
            [self addSubview:newButton];
        }
        
        frame.size.height += kCLMAlertViewDefaultButtonHeight;
        self.frame = frame;
    }
}

- (UIButton *)buttonWithTitle:(NSString *)title
{
    UIButton *newButton = [[UIButton alloc] initWithFrame:CGRectZero];
    newButton.titleLabel.text = title;
    [newButton setBackgroundColor:[UIColor blackColor]];
    [newButton addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    return newButton;
}

- (void)show
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self.center = window.center;
    self.backgroundColor = [UIColor whiteColor];
    [self setClipsToBounds:YES];
       
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    self.showAnimation(self);
}

- (void)dismiss
{
    if (self.dismissAnimation)
    {
        self.dismissAnimation(self);
    }else{
        [self removeFromSuperview];
    }
}

- (void)buttonSelected:(UIButton *)sender
{
    [self.buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if (obj == sender)
        {
            self.selectionBlock(self,idx);
            *stop = YES;
        }
        
    }];
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
        alertView.transform = CGAffineTransformMakeScale(0, 0);
        [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            alertView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }];
    
    [self setDismissAnimation:^(CLMAlertView *alertView){
        [UIView animateWithDuration:.5 animations:^{
            alertView.transform = CGAffineTransformMakeScale(0, 0);
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
