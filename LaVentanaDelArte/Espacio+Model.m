//
//  Espacio+Model.m
//  LaVentanaDelArte
//
//  Created by Ruben Jeronimo Fernandez on 15/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import "Espacio+Model.h"

NSString *const espacioEntityName = @"Espacio";

@implementation Espacio (Model)
+ (NSFetchRequest *) fetchAllEspaciosByName {
    NSSortDescriptor *nameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:espacioEntityName
                                                                       ascending:YES];
    NSFetchRequest *fetchRequest = [Espacio fetchAllEspaciosWithSortDescriptors:@[nameSortDescriptor]];
    
    return fetchRequest;
}


+ (NSFetchRequest *) fetchAllEspaciosWithSortDescriptors:(NSArray *)sortDescriptors {
    NSFetchRequest *fetchRequest = [Espacio baseFetchRequest];
    fetchRequest.sortDescriptors = sortDescriptors;
    
    return fetchRequest;
}


+ (NSFetchRequest *) fetchAllEspaciosByNameWithPredicate:(NSPredicate *)predicate {
    NSFetchRequest *fetchRequest = [Espacio fetchAllEspaciosByName];
    fetchRequest.predicate = predicate;
    
    return fetchRequest;
}


+ (NSFetchRequest *) baseFetchRequest {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:espacioEntityName];
    fetchRequest.fetchBatchSize = 20;
    
    return fetchRequest;
}
@end
