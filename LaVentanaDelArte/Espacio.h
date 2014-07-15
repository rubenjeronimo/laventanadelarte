//
//  Espacio.h
//  LaVentanaDelArte
//
//  Created by Ruben Jeronimo Fernandez on 15/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Espacio : NSManagedObject

@property (nonatomic, retain) NSString * descripcion;
@property (nonatomic, retain) NSNumber * latitud;
@property (nonatomic, retain) NSNumber * longitud;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * imagen;

@end
