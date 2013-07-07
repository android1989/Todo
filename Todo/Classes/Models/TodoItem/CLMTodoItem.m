//
//  CLMTodoItem.m
//  Todo
//
//  Created by Andrew Hulsizer on 5/23/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMTodoItem.h"
#import "CLMTodoDataManager.h"

static NSString * const kIdKey = @"IdKey";
static NSString * const kTitleKey = @"TitleKey";
static NSString * const kCheckedKey = @"CheckedKey";

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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.itemID = [aDecoder decodeObjectForKey:kIdKey];
        self.title = [aDecoder decodeObjectForKey:kTitleKey];
        self.checked = [aDecoder decodeBoolForKey:kCheckedKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.itemID forKey:kIdKey];
    [aCoder encodeObject:self.title forKey:kTitleKey];
    [aCoder encodeBool:self.checked forKey:kCheckedKey];
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
