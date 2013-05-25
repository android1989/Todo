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
@end
