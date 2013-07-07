//
//  CLMTodoDataManager.m
//  Todo
//
//  Created by Andrew Hulsizer on 5/23/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMTodoDataManager.h"
#import "CLMTodoItem.h"
#import "CLMTodoList.h"
#import "RestKit.h"
static CLMTodoDataManager *sharedManager = nil;

@interface CLMTodoDataManager ()
@property (nonatomic, strong) RKObjectManager *objectManager;
@property (nonatomic, strong) NSMutableArray *lists;
@end

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

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setupDataMapping];
    }
    return self;
}

- (void)saveData
{
    NSString *cachesFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *file = [cachesFolder stringByAppendingPathComponent:@"lists"];
    [NSKeyedArchiver archiveRootObject:self.lists toFile:file];
}
#pragma mark - RestKit Data Mapping

- (void)setupDataMapping
{
    NSURL *baseURL = [NSURL URLWithString:CLMBaseURL];
    self.objectManager = [RKObjectManager managerWithBaseURL:baseURL];
        
    RKObjectMapping *itemMapping = [RKObjectMapping mappingForClass:[CLMTodoItem class]];
    [itemMapping addAttributeMappingsFromDictionary:@{@"id":@"itemID",@"title":@"title",@"checked":@"checked"}];
    
    RKObjectMapping *listMapping = [RKObjectMapping mappingForClass:[CLMTodoList class]];
    [listMapping addAttributeMappingsFromDictionary:@{@"id":@"listID",@"title":@"title"}];
    
    RKRelationshipMapping *itemsForListRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:@"list_items" toKeyPath:@"items" withMapping:itemMapping];
    
    [listMapping addPropertyMapping:itemsForListRelationship];
    
    RKResponseDescriptor *listsResponse = [RKResponseDescriptor responseDescriptorWithMapping:listMapping pathPattern:CLMListsPath keyPath:@"" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    RKResponseDescriptor *itemResponse = [RKResponseDescriptor responseDescriptorWithMapping:itemMapping pathPattern:CLMItemsPath keyPath:@"" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.objectManager addResponseDescriptorsFromArray:@[listsResponse, itemResponse]];
}

#pragma mark - fetches

- (void)fetchLists:(dataCompletionBlock)completionBlock
{
    __weak CLMTodoDataManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSString *cachesFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *file = [cachesFolder stringByAppendingPathComponent:@"lists"];
        weakSelf.lists = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
        if (!weakSelf.lists)
        {
            weakSelf.lists = [[NSMutableArray alloc] init];
        }
        completionBlock(self.lists);
    });
    
//WEB
//    [self.objectManager getObjectsAtPath:CLMListsPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//        if (mappingResult)
//        {
//            if (completionBlock)
//            {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    completionBlock(mappingResult.array);
//                });
//            }
//        }
//    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
//        
//    }];
}

- (void)fetchList:(CLMTodoList *)list completionBlock:(dataCompletionBlock)completionBlock
{
    [self.objectManager getObjectsAtPath:CLMListsPath parameters:@{@"id":list.listID} success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (mappingResult)
        {
            if (completionBlock)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(mappingResult.firstObject);
                });
            }
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - posts

- (void)postNewList:(CLMTodoList *)list completionBlock:(dataCompletionBlock)completionBlock
{
    [self.objectManager postObject:nil path:CLMListsPath parameters:@{@"list_id":list.listID,@"title":list.title} success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
    }];

}

- (void)postNewItem:(CLMTodoItem *)newItem toList:(CLMTodoList *)list completionBlock:(dataCompletionBlock)completionBlock
{
    [self.objectManager postObject:nil path:CLMItemsPath parameters:@{@"list_id":list.listID,@"title":newItem.title,@"checked":@0} success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - puts

- (void)updateList:(CLMTodoList *)list completionBlock:(dataCompletionBlock)completionBlock
{
    [self.objectManager putObject:nil path:[CLMListsPath stringByAppendingFormat:@"/%@",list.listID] parameters:@{@"title":list.title} success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)updateItem:(CLMTodoItem *)item completionBlock:(dataCompletionBlock)completionBlock
{
    [self.objectManager putObject:nil path:[CLMItemsPath stringByAppendingFormat:@"/%@.json",item.itemID] parameters:@{@"title":item.title,@"checked":@(item.checked)} success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - deletes

- (void)deleteList:(CLMTodoList *)list completionBlock:(dataCompletionBlock)completionBlock
{
    [self.objectManager deleteObject:nil path:[CLMListsPath stringByAppendingFormat:@"/%@",list.listID] parameters:@{} success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)deleteItem:(CLMTodoItem *)item completionBlock:(dataCompletionBlock)completionBlock
{
    [self.objectManager deleteObject:nil path:[CLMItemsPath stringByAppendingFormat:@"/%@",item.itemID] parameters:@{} success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
    }];
}
@end
