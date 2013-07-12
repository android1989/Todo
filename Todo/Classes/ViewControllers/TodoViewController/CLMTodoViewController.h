//
//  CLMTodoViewController.h
//  Todo
//
//  Created by Andrew Hulsizer on 5/23/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLMBaseListViewController.h"
@class CLMTodoList;

@interface CLMTodoViewController : CLMBaseListViewController

@property (nonatomic, strong) CLMTodoList *list;
@end
