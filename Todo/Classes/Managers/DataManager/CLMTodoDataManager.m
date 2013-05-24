//
//  CLMTodoDataManager.m
//  Todo
//
//  Created by Andrew Hulsizer on 5/23/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMTodoDataManager.h"
#import "CLMTodoItem.h"

static CLMTodoDataManager *sharedManager = nil;

@implementation CLMTodoDataManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedManager)
        {
            sharedManager = [[CLMTodoDataManager alloc] init];
        }
    });
    
    return sharedManager;
}

- (NSArray *)items
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 5; i++)
    {
        CLMTodoItem *item = [[CLMTodoItem alloc] init];
        item.title = [NSString stringWithFormat:@"Item %d", i];
        item.checked = NO;
        [items addObject:item];
    }
    
    return items;
}
@end
