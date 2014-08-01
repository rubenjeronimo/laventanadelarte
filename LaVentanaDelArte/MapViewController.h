//
//  MapViewController.h
//  LaVentanaDelArte
//
//  Created by Ruben Jeronimo Fernandez on 20/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class  Espacio;
@interface MapViewController : UIViewController
@property (nonatomic,strong) Espacio *detalleEspacio;
@property (nonatomic,strong) NSManagedObjectContext *contexto;
-(void) setDetalleAnotacion;
-(void) POI;
@end
