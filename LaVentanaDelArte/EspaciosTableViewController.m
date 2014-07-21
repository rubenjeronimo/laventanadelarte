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
#import "addData.h"
@interface EspaciosTableViewController () <NSFetchedResultsControllerDelegate>
@property (nonatomic,strong) NSMutableArray *listadoEspacios;
@property (nonatomic,strong) NSDictionary *espacio;
@property (nonatomic,strong) NSMutableArray *listadoEventos;
@property (nonatomic,strong) NSDictionary *evento;

@end

@implementation EspaciosTableViewController{
    NSFetchedResultsController *_fetchedResultsController;
}

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

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    
        cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
        [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
    
}

-(void)viewWillAppear:(BOOL)animated{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    addData *addD = [[addData alloc]init];
    addD.contexto = self.contexto;
    [addD takeDataEspacios];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"spaces loaded"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"not Found"
                                               object:nil];
    [self reloadData];
}

- (void)receivedNotification:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"spaces loaded"]) {
        [self reloadData];
    } else if ([[notification name] isEqualToString:@"Not Found"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Results Found"
                                                            message:nil delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
}

-(NSMutableArray *)listadoEspacios{
    if (!_listadoEspacios) {
        _listadoEspacios = [[NSMutableArray alloc]init];
    }
    return _listadoEspacios;
}

- (void)reloadData {
    NSError *error = nil;
    
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Error fetching Eventos: %@", error.localizedDescription);
    }
    
    [self.tableView reloadData];
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return [[[self fetchedResultsController] sections] count];;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfItems = 0;
    
    if ([self fetchedResultsController].sections.count > 0) {
        id<NSFetchedResultsSectionInfo> sectionInfo = [self fetchedResultsController].sections[section];
        numberOfItems = [sectionInfo numberOfObjects];
    }
    
    return numberOfItems;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VentanaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    Espacio *espace = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    cell.NameEvento.text = espace.nombre;
    cell.typeEvento.text = espace.descripcion;
    NSURL *url = [NSURL URLWithString:espace.imagen];
    NSData *data = [NSData dataWithContentsOfURL:url];
    cell.ImageEvento.image = [UIImage imageWithData:data];
    [cell reDibujaSerie];

    return cell;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString: @"DetalleSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
        DetalleViewController *detalleVC = [segue destinationViewController];
        Espacio *espacio = [[self fetchedResultsController] objectAtIndexPath:indexPath];
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

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Espacio"];
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@", @"gale"];
    //    fetchRequest.predicate = predicate;
    fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"nombre" ascending:YES]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.contexto sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

- (IBAction)areaEstudio:(id)sender {
    UIActionSheet *as = [[UIActionSheet alloc]initWithTitle:@"Tipo de evento" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Arte Contemporaneo",@"Todos", nil];
    [as showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            NSLog(@"Arte Contemporaneo");
            [self.tableView reloadData];
            break;
        case 1:
            NSLog(@"Todos");
            [self.tableView reloadData];
            break;
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}


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


@end


