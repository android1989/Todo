//
//  CLMEditTransitionMediator.h
//  Todo
//
//  Created by Andrew Hulsizer on 5/25/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLMTodoViewController;
@class CLMEditItemViewController;
@class CLMTodoItem;

@interface CLMEditTransitionMediator : NSObject

@property (nonatomic, weak) CLMEditItemViewController *editViewController;
@property (nonatomic, weak) CLMTodoViewController *todoViewController;

- (void)transitionToEdit;
@end
