//
//  MapasViewController.m
//  LaVentanaDelArte
//
//  Created by Ruben Jeronimo Fernandez on 24/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import "MapasViewController.h"

@interface MapasViewController ()
@property (nonatomic) float latitudPOI;
@property (nonatomic) float longitudPOI;

@end

@implementation MapasViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.latitudPOI = 40.392756;
    self.longitudPOI = -3.693344;
    self.navigationController.navigationBar.barTintColor = [UIColor grayColor];
    self.navigationItem.title = @"Mapa";
    [self mapea];
    
    [self takeDetalle];
    

}

-(void)mapea{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta=0.1;
    span.longitudeDelta=0.1;
    CLLocationCoordinate2D location;
    location.latitude = self.latitudPOI;
    location.longitude = self.longitudPOI;
    region.span = span;
    region.center = location;
    MKCoordinateRegion fitRegion = [self.mapaView  regionThatFits:region];
    [self.mapaView setRegion:fitRegion animated:YES];
}

-(void) takeDetalle{
    if (self.espacioDetalle) {
        CLLocationCoordinate2D punto;
        punto.latitude = [self.espacioDetalle.latitud floatValue];
        punto.longitude = [self.espacioDetalle.longitud floatValue];
        MKPointAnnotation *anotacion = [[MKPointAnnotation alloc]init];
        anotacion.coordinate = punto;
        anotacion.title = self.espacioDetalle.nombre;
        
        [self.mapaView addAnnotation:anotacion];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKAnnotationView *mkView;
    mkView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"myBars"];
    
    if (!mkView) {
        mkView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"myBars"];
    }
    mkView.canShowCallout = YES;
    
    
//    if ([annotation isKindOfClass:[Espacio class]]) {
//        Espacio *espacio = (Espacio*)annotation;
//        switch ([espacio.tipo intValue]) {
//            case 0:
//                mkView.image = [UIImage imageNamed:@"museocontemporaneo.png"];
//                break;
//            case 1:
//                mkView.image = [UIImage imageNamed:@"museonormal.png"];
//                break;
//
//            default:
//                break;
//        }
//    }
    
    mkView.image = [UIImage imageNamed:@"museonormal.png"];
    
    return mkView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
