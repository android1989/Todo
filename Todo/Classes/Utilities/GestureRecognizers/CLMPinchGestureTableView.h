//
//  CLMPinchGestureTableView.h
//  Todo
//
//  Created by Andrew Hulsizer on 6/30/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CLMPinchGestureTableViewDelegate;

@interface CLMPinchGestureTableView : NSObject

- (instancetype)initWithTableView:(UITableView *)tableView;

@property (nonatomic, readonly) UITableView *tableView;
@property (nonatomic, weak) id<CLMPinchGestureTableViewDelegate> delegate;
@end

@protocol CLMPinchGestureTableViewDelegate <NSObject>

- (void)addNewItemAtIndex:(NSInteger)index;

@end
