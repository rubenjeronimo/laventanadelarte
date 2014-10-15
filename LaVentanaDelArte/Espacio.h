//
//  Espacio.h
//  LaVentanaDelArte
//
//  Created by Jose A. Herran on 15/10/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Evento;

@interface Espacio : NSManagedObject

@property (nonatomic, retain) NSString * cod_tipo;
@property (nonatomic, retain) NSString * direccion;
@property (nonatomic, retain) NSString * id_centro;
@property (nonatomic, retain) NSString * imagen;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSString * nombre_id;
@property (nonatomic, retain) NSString * provincia_id;
@property (nonatomic, retain) NSString * resumen;
@property (nonatomic, retain) NSString * tipologia;
@property (nonatomic, retain) NSString * web;
@property (nonatomic, retain) NSSet *evento;
@end

@interface Espacio (CoreDataGeneratedAccessors)

- (void)addEventoObject:(Evento *)value;
- (void)removeEventoObject:(Evento *)value;
- (void)addEvento:(NSSet *)values;
- (void)removeEvento:(NSSet *)values;

@end
