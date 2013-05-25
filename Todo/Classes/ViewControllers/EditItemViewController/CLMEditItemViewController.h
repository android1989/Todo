//
//  CLMEditItemViewController.h
//  Todo
//
//  Created by Andrew Hulsizer on 5/25/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLMTodoItem;
@protocol CLMEditItemViewControllerDelegate;

@interface CLMEditItemViewController : UIViewController

@property (nonatomic, weak) CLMTodoItem *item;
@property (nonatomic, weak) id<CLMEditItemViewControllerDelegate> delegate;
@end

@protocol CLMEditItemViewControllerDelegate <NSObject>
@required
- (void)editDidFinish;

@end