//
//  CLMApplicationViewController.h
//  Todo
//
//  Created by Andrew Hulsizer on 5/23/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLMListNavigationViewController;
@class CLMMenuViewController;

typedef void(^ApplicationLaunchBlock)(void);
@interface CLMApplicationViewController : UIViewController

@property (nonatomic, copy) ApplicationLaunchBlock applicationLaunchBlock;


@property (nonatomic, strong) CLMListNavigationViewController *listNavigationController;
@property (nonatomic, strong) CLMMenuViewController *menuViewController;
@end
