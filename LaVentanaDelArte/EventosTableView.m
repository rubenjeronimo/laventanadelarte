//
//  EventosTableView.m
//  LaVentanaDelArte
//
//  Created by Ruben Jeronimo Fernandez on 16/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import "EventosTableView.h"
#import "VentanaTableViewCell.h"
#import "Evento.h"
#import "DetalleViewController.h"
@interface EventosTableView()
@property (nonatomic,strong) NSMutableArray *listadoEventos;
@property (nonatomic,strong) NSDictionary *evento;
@end
@implementation EventosTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
/*
-(NSMutableArray*) listadoEventos{
    if (!_listadoEventos) {
        _listadoEventos = [[NSMutableArray alloc]init];
    }
    return  _listadoEventos;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [self.listadoEventos count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VentanaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    Evento *evento = [self.listadoEventos objectAtIndex:indexPath.row];
    cell.NameEvento.text = evento.name;
    cell.typeEvento.text = evento.descripcion;
    NSURL *url = [NSURL URLWithString:evento.imagen];
    NSData *data = [NSData dataWithContentsOfURL:url];
    cell.ImageEvento.image = [UIImage imageWithData:data];
    return cell;
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if ([segue.identifier isEqualToString: @"EventoSegue"]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
//        DetalleViewController *detalleVC = [segue destinationViewController];
//        Evento *evento = [self.listadoEventos objectAtIndex:indexPath.row];
//        detalleVC.espacio = evento;
//    }
//}


-(void) takeData{
    NSString *string = @"https://www.kimonolabs.com/api/eennv4bk?apikey=tjx9PaZRwpncvzd4YG9QBCEzD0bDWFgr";
    NSURL *urlEspacio = [NSURL URLWithString:string];
    NSURLRequest *consultaEvento = [NSURLRequest requestWithURL:urlEspacio];
    
    
    
    AFHTTPRequestOperation *operacion = [[AFHTTPRequestOperation alloc]initWithRequest:consultaEvento];
    operacion.responseSerializer = [AFJSONResponseSerializer serializer];
    [operacion setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.evento = (NSDictionary *)responseObject;
        NSArray *listadoTemporal = [self.evento valueForKeyPath:@"results.collection1"];
        for (NSDictionary *eve in listadoTemporal) {
            Evento *ev= [NSEntityDescription insertNewObjectForEntityForName:@"Espacio" inManagedObjectContext:self.contexto];
            ev.name = [eve valueForKeyPath:@"nombreExpo.text"];
            ev.descripcion = [eve valueForKeyPath:@"detalleExpo.text"];
            ev.imagen =[eve valueForKeyPath:@"imagenExpo.src"];
            
            [self.listadoEventos addObject:ev];
        }
       [self reloadData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"que mal");
    }];
    [operacion start];
    [self.contexto save:nil];
}
*/
@end
