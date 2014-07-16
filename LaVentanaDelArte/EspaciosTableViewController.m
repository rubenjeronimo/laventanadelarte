//
//  EventosTableViewController.m
//  LaVentanaDelArte
//
//  Created by Ruben Jeronimo Fernandez on 11/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import "EspaciosTableViewController.h"
#import "VentanaTableViewCell.h"
#import "DetalleViewController.h"
#import "Evento.h"
#import "Espacio.h"
@interface EspaciosTableViewController () 
@property (nonatomic,strong) NSMutableArray *listadoEspacios;
@property (nonatomic,strong) NSDictionary *espacio;
@property (nonatomic,strong) NSMutableArray *listadoEventos;
@property (nonatomic,strong) NSDictionary *evento;

@end

@implementation EspaciosTableViewController
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
    
    //[self cargaDatos];
    [self takeData];
    
    
}

-(NSMutableArray *)listadoEspacios{
    if (!_listadoEspacios) {
        _listadoEspacios = [[NSMutableArray alloc]init];
    }
    return _listadoEspacios;
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
    cell.typeEvento.text = espace.descripcion;
    NSURL *url = [NSURL URLWithString:espace.imagen];
    NSData *data = [NSData dataWithContentsOfURL:url];
    cell.ImageEvento.image = [UIImage imageWithData:data];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString: @"DetalleSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
        DetalleViewController *detalleVC = [segue destinationViewController];
        Espacio *espacio = [self.listadoEspacios objectAtIndex:indexPath.row];
        detalleVC.espacio = espacio;
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
    // Get the new view controller using [segue destinationViewControlddler].
    // Pass the selected object to the new view controller.
}
*/



#pragma mark - downloading Data
-(void)cargaDatos{
    Espacio *espacio1 = [NSEntityDescription insertNewObjectForEntityForName:@"Espacio" inManagedObjectContext:self.contexto];
    Espacio *espacio2 = [NSEntityDescription insertNewObjectForEntityForName:@"Espacio" inManagedObjectContext:self.contexto];
    Espacio *espacio3 = [NSEntityDescription insertNewObjectForEntityForName:@"Espacio" inManagedObjectContext:self.contexto];
    Espacio *espacio4 = [NSEntityDescription insertNewObjectForEntityForName:@"Espacio" inManagedObjectContext:self.contexto];
    espacio1.nombre = @"Centro Cultural La Corrala UAM";
    espacio2.nombre = @"Fundación de los Ferrocarriles Españoles";
    espacio3.nombre = @"Galería Alegría";
    espacio4.nombre = @"Galería Arte 10";
    espacio1.descripcion = @"Situado en el centro de la ciudad -en la histórica corrala de la calle de Carlos Arniches, en mitad de El Rastro-, La Corrala tiene por objetivo proyectar la creatividad y la capacidad de innovación científica de la Universidad Autónoma a todo Madrid.";
    espacio2.descripcion = @"El Palacio de Fernán Núñez es la sede de la Fundación de los Ferrocarriles Españoles desde 1985. En el palacio se organizan exposiciones temporales.";
    espacio3.descripcion = @"Apostamos por una programación en la que convivan artistas de corta, media y larga carrera con otros artistas absolutamente desconocidos fuera del circuito. La Galería Alegría es un espacio abierto al arte, al diseño y a todo aquello que nos interese y emocione";
    espacio4.descripcion = @"En la Galería Arte 10, podrás encontrar expuesta básicamente obra gráfica moderna y contemporánea, esculturas, objetos y libros de artista. Realiza exposiciones tituladas y/o temáticas de la Colección Arte 10, pero ocasionalmente también de artistas del momento.";
    espacio1.imagen = @"http://laventanadelarte.es/images/madrid/3874/foto-centro-2903142217318bb97c.jpg";
    espacio2.imagen = @"http://laventanadelarte.es/images/madrid/3892/foto-centro-0204141839342818b4.jpg";
    espacio3.imagen = @"http://laventanadelarte.es/images/madrid/3905/foto-centro-030414103516e1a1f2.jpg";
    espacio4.imagen = @"http://laventanadelarte.es/images/madrid/3917/foto-centro-030414103849a3f68e.jpg";
    espacio1.url = @"www.uam.es/ss/Satellite/es/1242657634005";
    espacio2.url = @"www.ffe.es";
    espacio3.url = @"www.galeriaalegria.es";
    espacio4.url = @"www.arte10galeria.com";
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
            Espacio *es= [NSEntityDescription insertNewObjectForEntityForName:@"Espacio" inManagedObjectContext:self.contexto];
            es.nombre = [eve valueForKeyPath:@"Name.text"];
            es.descripcion = [eve valueForKeyPath:@"Detail.text"];
            es.imagen =[eve valueForKeyPath:@"Image.src"];
            
            [self.listadoEspacios addObject:es];
        }
        [self.tableView reloadData];
       // NSLog(@"array:%@",self.listadoEventos);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"que mal");
    }];
    [operacion start];
    [self.contexto save:nil];
}

@end
