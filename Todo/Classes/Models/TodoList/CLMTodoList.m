//
//  CLMTodoList.m
//  Todo
//
//  Created by Andrew Hulsizer on 5/25/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMTodoList.h"
#import "CLMTodoDataManager.h"

@implementation CLMTodoList

- (void)addTodoItem:(CLMTodoItem *)newItem
{
    [[CLMTodoDataManager sharedManager] postNewItem:newItem toList:self completionBlock:^(id data) {
        NSLog(@"NEW ITEM POSTED");
    }];
    
    NSMutableArray *newArray = [self.items mutableCopy];
    [newArray addObject:newItem];
    self.items = newArray;
}

- (void)removeTodoItem:(CLMTodoItem *)item
{
    [[CLMTodoDataManager sharedManager] deleteItem:item completionBlock:^(id data) {
        NSLog(@"ITEM DELETED");
    }];
    
    NSMutableArray *newArray = [self.items mutableCopy];
    [newArray removeObject:item];
    self.items = newArray;
}
@end
