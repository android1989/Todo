//
//  CLMApplicationViewController.h
//  Todo
//
//  Created by Andrew Hulsizer on 5/23/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLMTodoViewController.h"

typedef void(^ApplicationLaunchBlock)(void);
@interface CLMApplicationViewController : UIViewController

@property (nonatomic, copy) ApplicationLaunchBlock applicationLaunchBlock;

@property (nonatomic, strong) CLMTodoViewController *todoViewController;
@end
