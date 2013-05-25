//
//  CLMTodoViewController.h
//  Todo
//
//  Created by Andrew Hulsizer on 5/23/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLMTodoList;

@interface CLMTodoViewController : UIViewController

@property (nonatomic, strong) CLMTodoList *list;
@end
