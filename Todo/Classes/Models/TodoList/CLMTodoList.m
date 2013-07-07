//
//  CLMTodoList.m
//  Todo
//
//  Created by Andrew Hulsizer on 5/25/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMTodoList.h"
#import "CLMTodoDataManager.h"

static NSString * const kIdKey = @"IdKey";
static NSString * const kTitleKey = @"TitleKey";
static NSString * const kItemsKey = @"ItemsKey";

@implementation CLMTodoList

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.listID = [aDecoder decodeObjectForKey:kIdKey];
        self.title = [aDecoder decodeObjectForKey:kTitleKey];
        self.items = [aDecoder decodeObjectForKey:kItemsKey];
        if (!self.items)
        {
            self.items = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.listID forKey:kIdKey];
    [aCoder encodeObject:self.title forKey:kTitleKey];
    [aCoder encodeObject:self.items forKey:kItemsKey];
}


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
