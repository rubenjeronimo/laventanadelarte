//
//  Espacio.h
//  LaVentanaDelArte
//
//  Created by Ruben Jeronimo Fernandez on 21/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Evento;

@interface Espacio : NSManagedObject

@property (nonatomic, retain) NSString * descripcion;
@property (nonatomic, retain) NSString * direccion;
@property (nonatomic, retain) NSString * imagen;
@property (nonatomic, retain) NSNumber * latitud;
@property (nonatomic, retain) NSNumber * longitud;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * tipo;
@property (nonatomic, retain) NSSet *evento;
@end

@interface Espacio (CoreDataGeneratedAccessors)

- (void)addEventoObject:(Evento *)value;
- (void)removeEventoObject:(Evento *)value;
- (void)addEvento:(NSSet *)values;
- (void)removeEvento:(NSSet *)values;

@end
