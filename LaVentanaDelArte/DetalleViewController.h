//
//  DetalleViewController.h
//  LaVentanaDelArte
//
//  Created by Ruben Jeronimo Fernandez on 14/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Espacio;
@class Evento;
@interface DetalleViewController : UIViewController
//@property (nonatomic,strong) NSString *nombreString;
//@property (nonatomic,strong) NSString *detalleString;
//@property (nonatomic,strong) NSString * urlString;
//@property (nonatomic,strong) NSString * latitud;
//@property (nonatomic,strong) NSString * longitud;
@property (nonatomic, strong) Espacio *espacio;
@property (nonatomic, strong) Evento *evento;
@property (weak, nonatomic) IBOutlet UILabel *nameEvento;
@property (weak, nonatomic) IBOutlet UITextView *detailEvento;
@property (weak, nonatomic) IBOutlet UIImageView *imageEvento;
@property (weak, nonatomic) IBOutlet UIButton *urlButton;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;

@end
