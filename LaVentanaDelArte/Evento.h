//
//  Evento.h
//  LaVentanaDelArte
//
//  Created by Ruben Jeronimo Fernandez on 15/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Espacio;

@interface Evento : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Espacio *space;

@end
