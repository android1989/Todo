//
//  CLMBaseListViewController.h
//  Todo
//
//  Created by Andrew Hulsizer on 7/8/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLMListNavigationViewController;

@interface CLMBaseListViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) CLMListNavigationViewController *navigationViewController;
@end
