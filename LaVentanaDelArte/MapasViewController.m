//
//  MapasViewController.m
//  LaVentanaDelArte
//
//  Created by Ruben Jeronimo Fernandez on 24/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import "MapasViewController.h"

@interface MapasViewController ()<NSFetchedResultsControllerDelegate>
@property (nonatomic) float latitudPOI;
@property (nonatomic) float longitudPOI;

@end

@implementation MapasViewController{
    NSFetchedResultsController *_fetchedResultsController;
}

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
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    NSString *direccionCompleta = [NSString stringWithFormat:@"%@,SPAIN",self.espacioDetalle.direccion];
    [geocoder geocodeAddressString:direccionCompleta completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark *aPlacemark in placemarks) {
            NSString *latDest1 = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.latitude];
            NSString *lngDest1 = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.longitude];
            self.latitudPOI = [latDest1 floatValue];
            self.longitudPOI = [lngDest1 floatValue];
        }
        self.navigationController.navigationBar.barTintColor = [UIColor grayColor];
        self.navigationItem.title = @"Mapa";
        [self mapea];
        [self POI];
        [self takeDetalle];
    }];
    
    
//    [geocoder geocodeAddressString:@"6138 Bollinger Road, San Jose, United States" completionHandler:^(NSArray* placemarks, NSError* error){
//        for (CLPlacemark* aPlacemark in placemarks)
//        {
//            // Process the placemark.
//            NSString *latDest1 = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.latitude];
//            NSString *lngDest1 = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.longitude];
//            lblDestinationLat.text = latDest1;
//            lblDestinationLng.text = lngDest1;
//        }
//    }

}

-(void)POI{
    CLLocationCoordinate2D POI;
    POI.latitude = self.latitudPOI;
    POI.longitude = self.longitudPOI;
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = POI;
    annotationPoint.title = [NSString stringWithFormat:@"%@", self.espacioDetalle.nombre];
    annotationPoint.subtitle = [NSString stringWithFormat:@"%@", self.espacioDetalle.direccion];
    [self.mapaView addAnnotation:annotationPoint];
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
//        punto.latitude = [self.espacioDetalle.latitud floatValue];
//        punto.longitude = [self.espacioDetalle.longitud floatValue];
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
- (IBAction)tipoMapa:(id)sender {
    UIActionSheet *as = [[UIActionSheet alloc]initWithTitle:@"Map Type" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"satellite",@"standard",@"hybrid", nil];
    [as showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self.mapaView setMapType:MKMapTypeSatellite];
            break;
        case 1:
            [self.mapaView setMapType:MKMapTypeStandard];
            break;
        case 2:
            [self.mapaView setMapType:MKMapTypeHybrid];
            break;
        default:
            break;
    }
}

- (IBAction)centrarMapa:(id)sender {
    //    self.latitudPOI = self.MapView.userLocation.coordinate.latitude;
    //    self.longitudPOI = self.MapView.userLocation.coordinate.longitude;
    
    [self mapea];
}


#pragma mark - fetchrequest
- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Espacio"];
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@", @"gale"];
    //    fetchRequest.predicate = predicate;
//    if (self.currentFilter == FilterTypeArts) {
//        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"tipo == %@", @(self.currentFilter)];
//    }
    
    fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"nombre" ascending:YES]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.contexto sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}


@end
