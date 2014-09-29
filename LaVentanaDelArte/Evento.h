//
//  Evento.h
//  LaVentanaDelArte
//
//  Created by Ruben Jeronimo Fernandez on 01/09/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Espacio;

@interface Evento : NSManagedObject

@property (nonatomic, retain) NSString * descripcion;
@property (nonatomic, retain) NSDate * fecha_fin;
@property (nonatomic, retain) NSDate * fecha_inicio;
@property (nonatomic, retain) NSString * foto;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSNumber * tipo;
@property (nonatomic, retain) Espacio *space;

@end
