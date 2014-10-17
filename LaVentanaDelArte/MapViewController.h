//
//  MapViewController.h
//  LaVentanaDelArte
//
//  Created by Ruben Jeronimo Fernandez on 20/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Espacio.h"

@class  Espacio;
@interface MapViewController : UIViewController
@property (nonatomic,strong) NSManagedObjectContext *contexto;
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,strong) Espacio *detalleEspacio;

-(void) setDetalleAnotacion;
-(void) POI;
@end
