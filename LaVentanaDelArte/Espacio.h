//
//  Espacio.h
//  LaVentanaDelArte
//
//  Created by Ruben Jeronimo Fernandez on 14/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Espacio : NSManagedObject

@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSNumber * latitud;
@property (nonatomic, retain) NSNumber * longitud;
@property (nonatomic, retain) NSString * descripcion;
@property (nonatomic, retain) NSString * url;


-(id)initWithName:(NSString *)name andURL: (NSString *) url;

@end
