//
//  CLMListCell.m
//  Todo
//
//  Created by Andrew Hulsizer on 5/25/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMListCell.h"

@interface CLMListCell () 
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
@end

@implementation CLMListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
        [self.contentView addSubview:view];
        
        [self configureFont];
        [self configureGestureRecognizer];
    }
    return self;
}

- (void)configureGestureRecognizer
{
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self addGestureRecognizer:longPressGestureRecognizer];
}

- (void)configureFont
{
    [_titleLabel setFont:[UIFont fontWithName:@"OpenSans-SemiboldItalic" size:14]];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        [self.delegate handleLongPress:self];
    }else if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        [self.delegate handleLongPressUp:self];
    }

}

- (void)transitionToDownStateWithDelay:(CGFloat)delay
{
    [UIView animateWithDuration:0.05 delay:delay options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        CGRect frame = self.mainContentView.frame;
        frame.size.width += 5;
        frame.size.height += 5;
        frame.origin.x -= 2;
        frame.origin.y -= 2;
        [self.mainContentView setFrame:frame];

        frame.origin.x += 4;
        frame.origin.y += 4;
        [self.shadowView setFrame:frame];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)transitionToNormalState
{
    [UIView animateWithDuration:.05 animations:^{
        CGRect frame = self.mainContentView.frame;
        frame.size.width -= 5;
        frame.size.height -= 5;
        frame.origin.x += 2;
        frame.origin.y += 2;
        [self.mainContentView setFrame:frame];
        [self.shadowView setFrame:frame];
    }];
}
@end
