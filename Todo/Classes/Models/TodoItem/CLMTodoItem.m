//
//  CLMTodoItem.m
//  Todo
//
//  Created by Andrew Hulsizer on 5/23/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMTodoItem.h"
#import "CLMTodoDataManager.h"

@implementation CLMTodoItem

- (id)init
{
    self = [super init];
    if (self)
    {
        _title = @"";
        _checked = NO;
    }
    return self;
}

- (void)updateChecked:(BOOL)checked
{
    _checked = checked;
    [[CLMTodoDataManager sharedManager] updateItem:self completionBlock:^(id data) {
        
    }];
    
}

- (void)updateTitle:(NSString *)title
{
    _title = title;
    [[CLMTodoDataManager sharedManager] updateItem:self completionBlock:^(id data) {
        
    }];
}
@end
