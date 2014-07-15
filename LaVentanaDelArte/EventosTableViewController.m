//
//  EventosTableViewController.m
//  LaVentanaDelArte
//
//  Created by Ruben Jeronimo Fernandez on 11/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import "EventosTableViewController.h"
#import "VentanaTableViewCell.h"
#import "DetalleViewController.h"
#import "Evento.h"
#import "Espacio.h"
@interface EventosTableViewController () 
@property (nonatomic,strong) NSMutableArray *listadoEspacios;
@property (nonatomic,strong) NSDictionary *espacio;
@property (nonatomic,strong) NSMutableArray *listadoEventos;
@property (nonatomic,strong) NSDictionary *evento;

@end

@implementation EventosTableViewController
static NSString *const name = @"name";
static NSString *const space = @"space";
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{

    //[self takeData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self cargaDatos];
    
    
}

-(void)cargaDatos{
    Espacio *espacio1 = [NSEntityDescription insertNewObjectForEntityForName:@"Espacio" inManagedObjectContext:self.contexto];
    Espacio *espacio2 = [NSEntityDescription insertNewObjectForEntityForName:@"Espacio" inManagedObjectContext:self.contexto];
    Espacio *espacio3 = [NSEntityDescription insertNewObjectForEntityForName:@"Espacio" inManagedObjectContext:self.contexto];
    Espacio *espacio4 = [NSEntityDescription insertNewObjectForEntityForName:@"Espacio" inManagedObjectContext:self.contexto];
    espacio1.nombre = @"espacio 1";
    espacio2.nombre = @"espacio 2";
    espacio3.nombre = @"espacio 3";
    espacio4.nombre = @"espacio 4";
    self.listadoEspacios = [[NSMutableArray alloc]init];
    self.listadoEventos = [[NSMutableArray alloc]init];
    [self.listadoEspacios addObject:espacio1];
    [self.listadoEspacios addObject:espacio2];
    [self.listadoEspacios addObject:espacio3];
    [self.listadoEspacios addObject:espacio4];
    
    [self.contexto save:nil];
}

-(void) takeData{
    NSString *string = @"https://www.kimonolabs.com/api/c4qaaysg?apikey=tjx9PaZRwpncvzd4YG9QBCEzD0bDWFgr";
    NSURL *urlEspacio = [NSURL URLWithString:string];
    NSURLRequest *consultaEvento = [NSURLRequest requestWithURL:urlEspacio];
    
    
    
    AFHTTPRequestOperation *operacion = [[AFHTTPRequestOperation alloc]initWithRequest:consultaEvento];
    operacion.responseSerializer = [AFJSONResponseSerializer serializer];
    [operacion setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.espacio = (NSDictionary *)responseObject;
        NSArray *listadoTemporal = [self.espacio valueForKeyPath:@"results.Lavapies"];
        for (NSDictionary *eve in listadoTemporal) {
            Espacio *es=[[Espacio alloc]init];
            es.nombre = [eve valueForKeyPath:@"Name.text"];

            [self.listadoEspacios addObject:es];
        }
        [self.tableView reloadData];
          NSLog(@"array:%@",self.listadoEventos);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"que mal");
    }];
    [operacion start];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.listadoEspacios count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VentanaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    Espacio *espace = [self.listadoEspacios objectAtIndex:indexPath.row];
    cell.NameEvento.text = espace.nombre;

    
    return cell;
}


//1.definir FetchresultController, 2.añadir observador al modelo, 3.cargar los datos cuando esté listo

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString: @"DetalleSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
        DetalleViewController *detalleVC = [segue destinationViewController];
        Espacio *espacio = [self.listadoEspacios objectAtIndex:indexPath.row];
        //NSString *tituloVC = [evento objectForKey:@"nombre"];
//        NSString *textDetailVC = [evento objectForKey:@"detail"];
//        NSString *latitudVC = [evento objectForKey:@"latitude"];
//        NSString *longitudVC = [evento objectForKey:@"longitude"];
//        NSString *urlVC = [evento objectForKey:@"url"];
        detalleVC.espacio = espacio;
        //detalleVC.nombreString = tituloVC;
//        detalleVC.detalleString = textDetailVC;
//        detalleVC.urlString = urlVC;
//        detalleVC.latitud = latitudVC;
//        detalleVC.longitud = longitudVC;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
