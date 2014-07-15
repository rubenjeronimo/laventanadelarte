//
//  DetalleViewController.m
//  LaVentanaDelArte
//
//  Created by Ruben Jeronimo Fernandez on 14/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import "DetalleViewController.h"
#import "Espacio.h"

@interface DetalleViewController ()

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
    self.title = self.espacio.nombre;
    self.detailEvento.text = self.espacio.descripcion;
    self.nameEvento.text = self.espacio.nombre;
    NSURL *url = [NSURL URLWithString:self.espacio.imagen];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.imageEvento.image = [UIImage imageWithData:data];
    self.urlButton.titleLabel.text = self.espacio.url;
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

@end
