//
//  CLMTodoDataManager.h
//  Todo
//
//  Created by Andrew Hulsizer on 5/23/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLMTodoItem;
@class CLMTodoList;

typedef void (^dataCompletionBlock)(id data);
@interface CLMTodoDataManager : NSObject

//singleton method
+ (instancetype)sharedManager;

- (void)fetchLists:(dataCompletionBlock)completionBlock;
- (void)fetchList:(CLMTodoList *)list completionBlock:(dataCompletionBlock)completionBlock;
- (void)postNewList:(CLMTodoList *)list completionBlock:(dataCompletionBlock)completionBlock;
- (void)postNewItem:(CLMTodoItem *)newItem toList:(CLMTodoList *)list completionBlock:(dataCompletionBlock)completionBlock;
- (void)updateList:(CLMTodoList *)list completionBlock:(dataCompletionBlock)completionBlock;
- (void)updateItem:(CLMTodoItem *)item completionBlock:(dataCompletionBlock)completionBlock;
@end
