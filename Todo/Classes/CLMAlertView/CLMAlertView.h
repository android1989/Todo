//
//  CLMAlertView.h
//  Todo
//
//  Created by Andrew Hulsizer on 7/14/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol CLMAlertViewDelegate;
@class CLMAlertView;

typedef NS_ENUM(NSInteger, CLMAlertViewAnimationStyle)
{
    CLMAlertViewAnimationStyleVertical, //Default
    CLMAlertViewAnimationStyleHorizontal,
    CLMAlertViewAnimationStyleGrowth
};

typedef void(^CLMAlertViewDidSelectItemBlock)(CLMAlertView * alertView, NSInteger buttonIndex);
typedef void(^CLMAlertViewShowAnimation)(CLMAlertView * alertView);
typedef void(^CLMAlertViewDismissAnimation)(CLMAlertView * alertView);
typedef void(^CLMAlertViewDismissAnimationCompletion)(CLMAlertView * alertView);

@interface CLMAlertView : UIView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
- (instancetype)initWithView:(UIView *)view delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message selectionBlock:(CLMAlertViewDidSelectItemBlock)selectionBlock cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
- (instancetype)initWithView:(UIView *)view selectionBlock:(CLMAlertViewDidSelectItemBlock)selectionBlock cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (void)show;

/****** NOTE ********
 If you plan on using this you are responsible for removing the alert view when finished animation in the dismissal block!!!!
 ****** FIN ********/
- (void)setCustomShowAnimationBlock:(CLMAlertViewShowAnimation)showAnimationBlock dismissBlock:(CLMAlertViewDismissAnimation)dismissAnimationBlock;

@property (nonatomic, weak) id<CLMAlertViewDelegate> delegate;
@property (nonatomic, assign) CLMAlertViewAnimationStyle animationStyle;
@end


@protocol CLMAlertViewDelegate <NSObject>
@optional

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)alertViewCancel:(UIAlertView *)alertView;

- (void)willPresentAlertView:(UIAlertView *)alertView;  // before animation and showing view
- (void)didPresentAlertView:(UIAlertView *)alertView;  // after animation

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex; // before animation and hiding view
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation

// Called after edits in any of the default fields added by the style
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView;

@end
