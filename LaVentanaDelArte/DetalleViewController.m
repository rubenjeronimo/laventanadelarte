//
//  DetalleViewController.m
//  LaVentanaDelArte
//
//  Created by Ruben Jeronimo Fernandez on 14/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import "DetalleViewController.h"
#import "Espacio.h"
#import "Evento.h"
#import "MapViewController.h"
#import <MessageUI/MessageUI.h>
@interface DetalleViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topTextFieldContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightTextFieldConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftTextFieldConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftButtonsConstraint;

@end

@implementation DetalleViewController

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
    // Do any additional setup after loading the view.
    
    if (self.espacio && !self.evento) {
        self.title = @"Ficha espacio";
        self.navigationController.navigationBar.alpha=0.5;
        self.detailEvento.text = self.espacio.descripcion;
        self.nameEvento.text = self.espacio.nombre;
        NSURL *url = [NSURL URLWithString:self.espacio.imagen];
        NSData *data = [NSData dataWithContentsOfURL:url];
        self.imageEvento.image = [UIImage imageWithData:data];

    }else if (self.evento && !self.espacio){
    
    self.title = @"Ficha exposición";
    self.detailEvento.text = self.evento.descripcion;
    self.nameEvento.text = self.evento.name;
    NSURL *url = [NSURL URLWithString:self.evento.imagen];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.imageEvento.image = [UIImage imageWithData:data];

    }
    [self reDibuja];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    self.topTextFieldContraint.constant = self.view.frame.size.width;
    [self reDibuja];
}

-(void) reDibuja{
    
    UIDeviceOrientation orientacion = [[UIDevice currentDevice]orientation];
    
    if (orientacion==UIDeviceOrientationPortrait || orientacion==UIDeviceOrientationUnknown) {
        [self setPortait];
        
    }else if (orientacion == UIDeviceOrientationLandscapeLeft || orientacion == UIDeviceOrientationLandscapeRight){
        [self setLandscape];
    }
}


-(void) setLandscape{
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.1];
    self.topTextFieldContraint.constant = 11;
    self.rightTextFieldConstraint.constant = 0;
    self.leftTextFieldConstraint.constant=320;
    self.topViewLabelConstraint.constant = 0;
    self.leftButtonsConstraint.constant = 320;
    [CATransaction commit];
    
}

-(void) setPortait{
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.1];
    self.topTextFieldContraint.constant = 320;
    self.rightTextFieldConstraint.constant = 8;
    self.leftTextFieldConstraint.constant=8;
    self.topViewLabelConstraint.constant = 250;
    self.leftButtonsConstraint.constant = 8;
    [CATransaction commit];
    
}










- (IBAction)mapDetailView:(id)sender {
    MapViewController *mapView = [self.storyboard instantiateViewControllerWithIdentifier:@"MapView"];
    [self presentViewController:mapView animated:YES completion:nil];
}

- (IBAction)LeerMas:(id)sender {
    NSURL        *url       = [NSURL URLWithString:@"http://www.laventanadelarte.es"];
    [[UIApplication sharedApplication] openURL:url];
}

@end
