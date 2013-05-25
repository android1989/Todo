//
//  CLMTodoItemCell.m
//  Todo
//
//  Created by Andrew Hulsizer on 5/23/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMTodoItemCell.h"

@interface CLMTodoItemCell () <UITextFieldDelegate>
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

#pragma mark - UIPanGestureRecognizer

- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)panRecognizer
{
    if(panRecognizer.state == UIGestureRecognizerStateEnded)
    {
        //All fingers are lifted.
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.backgroundImageView.center = CGPointMake( 160,
                                                          panRecognizer.view.center.y);
            
            CGRect titleFieldFrame = self.titleField.frame;
            titleFieldFrame.origin.x = 20;
            self.titleField.frame = titleFieldFrame;

            
            CGRect frame = self.strikeThrough.frame;
            frame.size.width = 0*CGRectGetWidth(self.titleField.frame);
            frame.origin.x = CGRectGetMinX(self.titleField.frame);
            [self.strikeThrough setFrame:frame];
        
        } completion:^(BOOL finished) {
            
        }];
        return;
    }
    CGPoint translation = [panRecognizer translationInView:self.backgroundImageView];
    
    if ((panRecognizer.view.center.x) > 210 || (panRecognizer.view.center.x) < 110)
    {
        translation.x *= .2;
    }
    
    CGFloat newXPosition = panRecognizer.view.center.x + translation.x;
    
   
    self.backgroundImageView.center = CGPointMake( newXPosition,
                                         panRecognizer.view.center.y);
    
    CGRect titleFieldFrame = self.titleField.frame;
    titleFieldFrame.origin.x = titleFieldFrame.origin.x+translation.x;
    self.titleField.frame = titleFieldFrame;
    
    CGFloat fraction = MIN(MAX((newXPosition-160)/50.0f,0.0f), 1.0f);
    CGRect frame = self.strikeThrough.frame;
    frame.size.width = fraction*CGRectGetWidth(self.titleField.frame);
    frame.origin.x = CGRectGetMinX(self.titleField.frame);
    [self.strikeThrough setFrame:frame];
    
    [panRecognizer setTranslation:CGPointMake(0, 0) inView:self.backgroundImageView];
    
}

@end
