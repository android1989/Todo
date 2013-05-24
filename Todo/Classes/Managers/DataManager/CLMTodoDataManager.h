//
//  CLMTodoDataManager.h
//  Todo
//
//  Created by Andrew Hulsizer on 5/23/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLMTodoDataManager : NSObject

//singleton method
+ (instancetype)sharedManager;

- (NSArray *)items;
@end
