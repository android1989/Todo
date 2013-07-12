//
//  CLMListToItemsMediator.h
//  Todo
//
//  Created by Andrew Hulsizer on 7/8/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLMBaseListViewController;

typedef NS_ENUM(NSInteger, CLMTransitionDirection)
{
    CLMTransitionDirectionLeft = -1,
    CLMTransitionDirectionRight = 1
};
@interface CLMListNavigationViewController : UIViewController

- (instancetype)initWithRootListViewController:(CLMBaseListViewController *)root;
- (void)pushBaseListViewController:(CLMBaseListViewController *)baseListViewController fromIndex:(NSInteger)index;
- (void)popBaseListViewControllerByPercentage:(CGFloat)percent;
- (void)popBaseListViewController;
@end
