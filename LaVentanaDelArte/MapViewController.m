//
//  MapViewController.m
//  LaVentanaDelArte
//
//  Created by Ruben Jeronimo Fernandez on 20/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController ()<MKMapViewDelegate,UIActionSheetDelegate,NSFetchedResultsControllerDelegate>
@property  double latitudPOI;
@property double longitudPOI;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISwitch *searchPoint;
@property (nonatomic,strong) CLLocation *selectedLocation;
@property (nonatomic,strong) NSMutableArray *cameras;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *anchoToolBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *anchoMapa;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *altoMapa;
@property (strong,nonatomic) NSFetchRequest *espaciosFetchRequest;
@property (nonatomic) Espacio *espacio;
@end

@implementation MapViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated{
    
    [self setAnchoToolBar];
    self.latitudPOI = 40.392756;
    self.longitudPOI = -3.693344;
    [self mapea];
    [self POI];
    
    for (Espacio *space in [self.fetchedResultsController fetchedObjects]) {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        NSString *direccionCompleta = [NSString stringWithFormat:@"%@,SPAIN",space.direccion];
        [geocoder geocodeAddressString:direccionCompleta completionHandler:^(NSArray *placemarks, NSError *error) {
            for (CLPlacemark *aPlacemark in placemarks) {
                NSString *latDest1 = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.latitude];
                NSString *lngDest1 = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.longitude];
                self.latitudPOI = [latDest1 floatValue];
                self.longitudPOI = [lngDest1 floatValue];
                
                CLLocationCoordinate2D POI;
                POI.latitude = self.latitudPOI;
                POI.longitude = self.longitudPOI;
                [self mapea:POI];
                MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
                annotationPoint.coordinate = POI;
                annotationPoint.title = [NSString stringWithFormat:@"%@", space.nombre];
                annotationPoint.subtitle = [NSString stringWithFormat:@"%@", space.direccion];
                [self.mapView addAnnotation:annotationPoint];

            }
        }];
        
    }
    

//    CLLocationCoordinate2D punto;
//    punto.latitude = self.latitudPOI;
//    punto.longitude = self.longitudPOI;
//    MKPointAnnotation *anotacion = [[MKPointAnnotation alloc]init];
//    anotacion.coordinate = punto;
//    anotacion.title = @"no vamos mal";
//
//    [self.MapView addAnnotation:anotacion];

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
    MKCoordinateRegion fitRegion = [self.mapView  regionThatFits:region];
    [self.mapView setRegion:fitRegion animated:YES];
}
-(void)mapea:(CLLocationCoordinate2D)conCoordenadas{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta=0.1;
    span.longitudeDelta=0.1;
    CLLocationCoordinate2D location;
    location.latitude = conCoordenadas.latitude;
    location.longitude = conCoordenadas.longitude;
    region.span = span;
    region.center = location;
    MKCoordinateRegion fitRegion = [self.mapView  regionThatFits:region];
    [self.mapView setRegion:fitRegion animated:YES];
}


- (IBAction)tipoMapa:(id)sender {
    UIActionSheet *as = [[UIActionSheet alloc]initWithTitle:@"Map Type" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"satellite",@"standard",@"hybrid", nil];
    [as showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self.mapView setMapType:MKMapTypeSatellite];
            break;
        case 1:
            [self.mapView setMapType:MKMapTypeStandard];
            break;
        case 2:
            [self.mapView setMapType:MKMapTypeHybrid];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    
//    [self POI];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(receivedNotification:)
//                                                 name:@"spaces loaded"
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(receivedNotification:)
//                                                 name:@"not Found"
//                                               object:nil];
    [self setAnchoToolBar];
    self.latitudPOI = 40.392756;
    self.longitudPOI = -3.693344;
//    CLLocationCoordinate2D punto;
//    punto.latitude = self.latitudPOI;
//    punto.longitude = self.longitudPOI;
//    MKPointAnnotation *anotacion = [[MKPointAnnotation alloc]init];
//    anotacion.coordinate = punto;
//    anotacion.title = @"no vamos mal";
//    
//    [self.MapView addAnnotation:anotacion];
    [self setDetalleAnotacion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setAnchoToolBar{
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.1];
    self.anchoToolBar.constant = self.view.frame.size.width;
    self.anchoMapa.constant = self.view.frame.size.width;
    self.altoMapa.constant = self.view.frame.size.height;
    [CATransaction commit];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self setAnchoToolBar];
}


//añadir una observacion a la notificacion spaces loaded de addData para que repinte los datos cargados. condicion multi-hilo


- (NSFetchRequest *)espaciosFetchRequest
{
    
    if (_espaciosFetchRequest != nil)
    {
        return _espaciosFetchRequest;
    }
    
    _espaciosFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Espacio" inManagedObjectContext:self.contexto];
    [_espaciosFetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"nombre" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [_espaciosFetchRequest setSortDescriptors:sortDescriptors];
    
    return _espaciosFetchRequest;
}



- (NSArray *)fetchInMOC:(NSManagedObjectContext *)moc withCentroId:(NSString *)centro_id {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Espacios"]; //Todos los campos de la entidad alarma.
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"centro_id == %@", centro_id]; // Cuando el campo alarmStockId sea igual al parametro de la función.
    [fetchRequest setPredicate:predicate]; //Aplicamos el filtro al fetchreques, con lo que solo devolverá de la tabla alarmas lo que hayamos recibido en el parámetro de la función.
    
    NSError *error;
    NSArray *results = [moc executeFetchRequest:fetchRequest error:&error]; //Ejecutamos el fetch request sobre el contexto.
    
    return results;
}


- (void)receivedNotification:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"spaces loaded"]) {
        NSLog(@"ya he cargado espacios");
        [self POI];

    } else if ([[notification name] isEqualToString:@"Not Found"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Results Found"
                                                            message:nil delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
}

-(void) setDetalleAnotacion{
    CLLocationCoordinate2D punto;
//        punto.latitude = [self.detalleEspacio.latitud floatValue];
//        punto.longitude = [self.detalleEspacio.longitud floatValue];
        MKPointAnnotation *anotacion = [[MKPointAnnotation alloc]init];
        anotacion.coordinate = punto;
        anotacion.title = self.detalleEspacio.nombre;
    [self.mapView annotations];
        [self.mapView addAnnotation:anotacion];
    [self.mapView setNeedsDisplay];
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKAnnotationView *mkView;
    mkView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"myBars"];
    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"myBars"];
    pinView.animatesDrop= YES;
    pinView.pinColor = MKPinAnnotationColorGreen;
    pinView.canShowCallout = YES;
//    if (!mkView) {
//        mkView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"myBars"];
//    }
    pinView.canShowCallout = YES;
     return pinView;
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




/*
-(void)addCameraUsingBar:(Bar*)barPoi{
    MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:barPoi.coordinate fromEyeCoordinate:barPoi.coordinate eyeAltitude:500];
    [camera setPitch:60];
    //    Bar *nextBarLocation = [self.listadoBares objectAtIndex:[barPoi]];
    [camera setHeading:200];
    [self.cameras addObject:camera];
}

- (IBAction)fly:(id)sender {
    self.cameras = [[NSMutableArray alloc]init];
    for (Bar *b in self.listadoBares) {
        [self addCameraUsingBar:b];
    }
    [self goToNextCamera];
}

-(void)goToNextCamera{
    if ([self.cameras count]==0) {
        return;
    }
    
    MKMapCamera *nextCamera = [self.cameras firstObject];
    [self.cameras removeObjectAtIndex:0];
    [UIView animateWithDuration:2.5
                          delay:.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.MapView setCamera:nextCamera];}
                     completion:^(BOOL finished) {
                         [self goToNextCamera];
                     }];
    
}
*/



-(void)POI{
    NSLog(@"pasando por POI");
//    for (Espacio *espacio in self.fetchedResultsController.fetchedObjects) {
//        espacio.latitud = [NSNumber numberWithFloat:[self randomFloatBetween:40.39 and:40.41]];
//        espacio.longitud= [NSNumber numberWithFloat:[self randomFloatBetween:-3.71 and:-3.68]];
        
//        CLLocationCoordinate2D coorPunto = CLLocationCoordinate2DMake([espacio.latitud floatValue],[espacio.longitud floatValue]);
//        MKPointAnnotation *anotacion = [[MKPointAnnotation alloc]init];
//        [anotacion setCoordinate:coorPunto];
        
//        [self.mapView addAnnotation:anotacion];
//    }
    
}

- (CGFloat)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

@end
