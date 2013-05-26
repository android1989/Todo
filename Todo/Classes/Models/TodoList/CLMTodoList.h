//
//  CLMTodoList.h
//  Todo
//
//  Created by Andrew Hulsizer on 5/25/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLMTodoItem;

@interface CLMTodoList : NSObject
@property (nonatomic, strong) NSNumber *listID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *items;

- (void)addTodoItem:(CLMTodoItem *)newItem;
- (void)removeTodoItem:(CLMTodoItem *)item;
@end
