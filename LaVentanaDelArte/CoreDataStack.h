//
//  RMMCoreDataStack.m
//
//  Created by Ricardo Maqueda on 04/11/14.
//  Copyright (c) 2013 Agbo. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;

@interface CoreDataStack : NSObject

@property (strong, nonatomic, readonly) NSManagedObjectContext *context;


+ (NSString *)persistentStoreCoordinatorErrorNotificationName;
+ (instancetype)coreDataStackWithModelName:(NSString *)aModelName databaseFilename:(NSString *)aDBName;
+ (instancetype)coreDataStackWithModelName:(NSString *)aModelName;
+ (instancetype)coreDataStackWithModelName:(NSString *)aModelName databaseURL:(NSURL *)aDBURL;

- (id)initWithModelName:(NSString *)aModelName databaseURL:(NSURL *)aDBURL;
- (void)zapAllData;
- (void)saveWithErrorBlock:(void(^)(NSError *error))errorBlock;
- (NSArray *)executeRequest:(NSFetchRequest *)request withError:(void(^)(NSError *error))errorBlock;

@end
