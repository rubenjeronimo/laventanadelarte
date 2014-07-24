//
//  MapasViewController.h
//  LaVentanaDelArte
//
//  Created by Ruben Jeronimo Fernandez on 24/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Espacio.h"
@interface MapasViewController : UIViewController
@property (weak, nonatomic) IBOutlet MKMapView *mapaView;
@property (nonatomic,strong) Espacio *espacioDetalle;
@end
