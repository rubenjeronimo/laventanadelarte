//
//  MapViewController.m
//  LaVentanaDelArte
//
//  Created by Ruben Jeronimo Fernandez on 20/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "Espacio.h"
@interface MapViewController ()<MKMapViewDelegate,UIActionSheetDelegate>
@property  double latitudPOI;
@property double longitudPOI;
@property (weak, nonatomic) IBOutlet MKMapView *MapView;
@property (weak, nonatomic) IBOutlet UISwitch *searchPoint;
@property (nonatomic,strong) CLLocation *selectedLocation;
@property (nonatomic,strong) NSMutableArray *cameras;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *anchoToolBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *anchoMapa;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *altoMapa;
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

    CLLocationCoordinate2D punto;
    punto.latitude = self.latitudPOI;
    punto.longitude = self.longitudPOI;
    MKPointAnnotation *anotacion = [[MKPointAnnotation alloc]init];
    anotacion.coordinate = punto;
    anotacion.title = @"no vamos mal";

    [self.MapView addAnnotation:anotacion];
}

-(void)mapea{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta=0.2;
    span.longitudeDelta=0.2;
    CLLocationCoordinate2D location;
    location.latitude = self.latitudPOI;
    location.longitude = self.longitudPOI;
    region.span = span;
    region.center = location;
    MKCoordinateRegion fitRegion = [self.MapView  regionThatFits:region];
    [self.MapView setRegion:fitRegion animated:YES];
}
-(void)mapea:(CLLocationCoordinate2D)conCoordenadas{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta=0.2;
    span.longitudeDelta=0.2;
    CLLocationCoordinate2D location;
    location.latitude = conCoordenadas.latitude;
    location.longitude = conCoordenadas.longitude;
    region.span = span;
    region.center = location;
    MKCoordinateRegion fitRegion = [self.MapView  regionThatFits:region];
    [self.MapView setRegion:fitRegion animated:YES];
}


- (IBAction)tipoMapa:(id)sender {
    UIActionSheet *as = [[UIActionSheet alloc]initWithTitle:@"Map Type" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"satellite",@"standard",@"hybrid", nil];
    [as showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self.MapView setMapType:MKMapTypeSatellite];
            break;
        case 1:
            [self.MapView setMapType:MKMapTypeStandard];
            break;
        case 2:
            [self.MapView setMapType:MKMapTypeHybrid];
            break;
        default:
            break;
    }
}

- (IBAction)centrarMapa:(id)sender {
    self.latitudPOI = self.MapView.userLocation.coordinate.latitude;
    self.longitudPOI = self.MapView.userLocation.coordinate.longitude;
    
    [self mapea];
}

- (void)viewDidLoad
{
    [super viewDidLoad];


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


-(void)POI{
    for (Espacio *espacio in self.contexto) {
        //        CLLocationCoordinate2D coorPunto = CLLocationCoordinate2DMake(self.latitudPOI, self.longitudPOI);
        //        MKPointAnnotation *anotacion = [[MKPointAnnotation alloc]init];
        //        [anotacion setCoordinate:coorPunto];
        
        [self.MapView addAnnotation:espacio];
    }
    
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
@end
