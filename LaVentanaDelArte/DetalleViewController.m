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
#import <Social/Social.h>
#import <Twitter/Twitter.h>
#import "MapasViewController.h"
@interface DetalleViewController ()<MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topTextFieldContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightTextFieldConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftTextFieldConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftButtonsConstraint;
@property (nonatomic,strong) SLComposeViewController *mySLComposerSheet;
@property (weak, nonatomic) IBOutlet UIButton *botonLike;
@property (weak, nonatomic) IBOutlet UIButton *botonUnlike;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightViewTitulo;
@property (weak, nonatomic) IBOutlet UILabel *centroLabel;

@property (weak, nonatomic) IBOutlet UIButton *botonMapa;
@property (weak, nonatomic) IBOutlet UIButton *botonLeerMas;
@property (weak, nonatomic) IBOutlet UILabel *labelCentroDesdeEvento;

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
        self.labelCentroDesdeEvento.hidden=YES;
        self.botonMapa.hidden=NO;
        self.botonLeerMas.hidden=NO;
        self.title = @"Ficha espacio";
        self.navigationController.navigationBar.alpha=0.5;
        self.detailEvento.text = self.espacio.resumen;
        self.nameEvento.text = self.espacio.nombre;
        self.centroLabel.text = @"";
        NSString *fotoInicio = @"http://laventana.solytek.es/images";
        NSString *imString = [NSString stringWithFormat:@"%@/%@/%@/%@", fotoInicio, self.espacio.provincia_id, self.espacio.id_centro,self.espacio.imagen];
        NSURL *url = [NSURL URLWithString:imString];
        NSData *data = [NSData dataWithContentsOfURL:url];
        self.imageEvento.image = [UIImage imageWithData:data];

    }else if (self.evento && !self.espacio){
        self.botonMapa.hidden=YES;
        self.botonLeerMas.hidden=YES;
                self.labelCentroDesdeEvento.hidden=NO;
        self.labelCentroDesdeEvento.text = self.evento.centro;
        
    self.title = @"Ficha exposición";
    self.detailEvento.text = self.evento.resumen;
    self.nameEvento.text = self.evento.nombre;
        NSString *centroLabelString = self.evento.fecha_fin;
    self.centroLabel.text = [NSString stringWithFormat: @"Hasta el:%@",centroLabelString];
        NSString *fotoInicio = @"http://laventana.solytek.es/images";
        NSString *imString = [NSString stringWithFormat:@"%@/%@/%@/%@/%@", fotoInicio, self.evento.provincia_id, self.evento.id_centro,self.evento.id_expo,self.evento.foto];
    NSURL *url = [NSURL URLWithString:imString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.imageEvento.image = [UIImage imageWithData:data];

    }
    
    self.urlButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.urlButton.layer.borderWidth = 1.0;
    self.urlButton.layer.cornerRadius = 5.0;
    self.mapButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.mapButton.layer.borderWidth = 1.0;
    self.mapButton.layer.cornerRadius = 5.0;
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
    self.heightViewTitulo.constant = 50;
    [CATransaction commit];
    
}

-(void) setPortait{
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.1];
    self.topTextFieldContraint.constant = 300;
    self.rightTextFieldConstraint.constant = 8;
    self.leftTextFieldConstraint.constant=8;
    self.topViewLabelConstraint.constant = 225;
    self.leftButtonsConstraint.constant = 8;
    self.heightViewTitulo.constant = 60;
    [CATransaction commit];
    
}




- (IBAction)shareWithOthers:(id)sender {
    if (!self.espacio && self.evento) {
        NSString *nombre = self.evento.nombre;
        NSString *body = [NSString stringWithFormat:@"I think that %@ is a good suggestion for you",nombre];
        NSString *imagen = self.evento.foto;
        NSString *fotoInicio = @"http://laventana.solytek.es/images";
        NSString *imString = [NSString stringWithFormat:@"%@/%@/%@/%@/%@", fotoInicio, self.evento.provincia_id, self.evento.id_centro,self.evento.id_expo,imagen];
        NSURL *url = [NSURL URLWithString:imString];
        UIImage *imagenShare = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        UIActivityViewController *controller =
        [[UIActivityViewController alloc]
         initWithActivityItems:@[body, imagenShare]
         applicationActivities:nil];
        [controller setValue:body forKey:@"subject"];
        controller.excludedActivityTypes = @[UIActivityTypePostToWeibo,
                                             UIActivityTypeMessage,
                                             
                                             UIActivityTypePrint,
                                             UIActivityTypeCopyToPasteboard,
                                             UIActivityTypeAssignToContact,
                                             UIActivityTypeSaveToCameraRoll,
                                             UIActivityTypeAddToReadingList,
                                             UIActivityTypePostToFlickr,
                                             UIActivityTypePostToVimeo,
                                             UIActivityTypePostToTencentWeibo,
//                                             UIActivityTypeAirDrop
                                             ];
        [self presentViewController:controller animated:YES completion:nil];
    }else if (self.espacio && !self.evento){
        NSString *nombre = self.espacio.nombre;
        NSString *body = [NSString stringWithFormat:@"I think that %@ is a good suggestion for you",nombre];
        NSString *imagen = self.espacio.imagen;
        NSString *fotoInicio = @"http://laventana.solytek.es/images";
        NSString *imString = [NSString stringWithFormat:@"%@/%@/%@/%@", fotoInicio, self.espacio.provincia_id, self.espacio.id_centro,imagen];
        NSURL *url = [NSURL URLWithString:imString];
        UIImage *imagenShare = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        
        UIActivityViewController *controller =
        [[UIActivityViewController alloc]
         initWithActivityItems:@[body, imagenShare]
         applicationActivities:nil];
        [controller setValue:body forKey:@"subject"];
        controller.excludedActivityTypes = @[UIActivityTypePostToWeibo,
                                             UIActivityTypeMessage,
                                             
                                             UIActivityTypePrint,
                                             UIActivityTypeCopyToPasteboard,
                                             UIActivityTypeAssignToContact,
                                             UIActivityTypeSaveToCameraRoll,
                                             UIActivityTypeAddToReadingList,
                                             UIActivityTypePostToFlickr,
                                             UIActivityTypePostToVimeo,
                                             UIActivityTypePostToTencentWeibo,
//                                             UIActivityTypeAirDrop
                                             ];
        [self presentViewController:controller animated:YES completion:nil];
    }
        

   
    
    
    
//    UIActionSheet *as = [[UIActionSheet alloc]initWithTitle:@"Comparte" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"e-mail",@"Twitter",@"Facebook", nil];
//    [as showInView:self.view];
    
}
/*
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self sendMail];
            break;
        case 1:
            [self sendTwitter];
            break;
        case 2:
            [self sendFacebook];
            break;
        default:
            break;
    }
}

-(void)sendMail{
    NSString *nombre = self.evento.name;
    NSString *body = [NSString stringWithFormat:@"I think that %@ is a good suggestion for you",nombre];
    
    NSString *emailTitle = @"Suggestion from La Ventana del Arte";
    NSString *messageBody = body;
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    
    [self presentViewController:mc animated:YES completion:NULL];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }

    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void) sendTwitter{
    NSString *nombre = self.evento.name;
    NSString *body = [NSString stringWithFormat:@"I think that %@ is a good suggestion for you",nombre];
    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];

    [twitter setInitialText:body];
//    [twitter addImage:[UIImage imageNamed:@"image.png"]];
    
    [self presentViewController:twitter animated:YES completion:nil];
    
    twitter.completionHandler = ^(TWTweetComposeViewControllerResult res) {
        
        if(res == TWTweetComposeViewControllerResultDone) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"The Tweet was posted successfully." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
            
            [alert show];
            
        }
        if(res == TWTweetComposeViewControllerResultCancelled) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Cancelled" message:@"You Cancelled posting the Tweet." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
            
            [alert show];
            
        }
        [self dismissModalViewControllerAnimated:YES];
        
    };
    
}

-(void)sendFacebook{
    if(![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])  {
        NSLog(@"log output of your choice here");
    }
    // Facebook may not be available but the SLComposeViewController will handle the error for us.

    self.mySLComposerSheet = [[SLComposeViewController alloc] init];
    self.mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    NSString *nombre = self.evento.name;
    NSString *body = [NSString stringWithFormat:@"I think that %@ is a good suggestion for you",nombre];
    [self.mySLComposerSheet setInitialText:body];
//    [self.mySLComposerSheet addImage:self.photos.firstObject]; //an image you could post
    
    [self presentViewController:self.mySLComposerSheet animated:YES completion:nil];
    
    [self.mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        NSString *output;
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                output = @"Action Cancelled";
                break;
            case SLComposeViewControllerResultDone:
                output = @"Post Successfull";
                break;
            default:
                break;
        }
        if (![output isEqualToString:@"Action Cancelled"]) {
            // Only alert if the post was a success. Or not! Up to you.
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
    }];
}
*/

#pragma mark - segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"detalleMapaSegue"]) {
        MapViewController *mapView = [self.storyboard instantiateViewControllerWithIdentifier:@"MapView"];
        mapView.detalleEspacio = self.espacio;
        [mapView setDetalleAnotacion];
    }
}





- (IBAction)mapDetailView:(id)sender {
    MapViewController *mapView = [self.storyboard instantiateViewControllerWithIdentifier:@"MapView"];
    mapView.detalleEspacio = self.espacio;
    [self presentViewController:mapView animated:YES completion:nil];
}

- (IBAction)LeerMas:(id)sender {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@", self.espacio.web]];
//        NSURL *url = [NSURL URLWithString:@"https://www.landgraphix.eu"];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)likeButton:(id)sender {
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.2];
    self.botonUnlike.alpha = 0.2;
    self.botonLike.alpha = 1;
    [CATransaction commit];
}
- (IBAction)unlikeButton:(id)sender {
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.2];
    self.botonUnlike.alpha = 1;
    self.botonLike.alpha = 0.2;
    [CATransaction commit];
}

- (IBAction)mapaVista:(id)sender {
    MapasViewController *mapasVC = [self.storyboard instantiateViewControllerWithIdentifier:@"vistaMapaStoryboard"];
    [self.navigationController pushViewController:mapasVC animated:YES];
    
    mapasVC.espacioDetalle = self.espacio;
}

@end
