//
//  UITableView+CellSwitch.h
//  Todo
//
//  Created by Andrew Hulsizer on 5/23/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (CellSwitch)

- (void)switchCellAtIndexPath:(NSIndexPath *)firstCellIndexPath withCellAtIndexPath:(NSIndexPath *)secondCellIndexPath;
@end
