//
//  EventosViewController.m
//  LaVentanaDelArte
//
//  Created by Ruben Jeronimo Fernandez on 16/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import "EventosViewController.h"
#import "VentanaTableViewCell.h"
#import "Evento.h"
#import "addData.h"
@interface EventosViewController () <NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *listadoEventos;
@property (nonatomic,strong) NSDictionary *evento;

@end

@implementation EventosViewController {
    NSFetchedResultsController *_fetchedResultsController;

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
    
    [self reloadData];
    addData *addD = [[addData alloc]init];
    addD.contexto = self.contexto;
    [addD takeDataEventos];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"events loaded"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"not Found"
                                               object:nil];
}

- (void)receivedNotification:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"events loaded"]) {
        [self reloadData];
    } else if ([[notification name] isEqualToString:@"Not Found"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Results Found"
                                                            message:nil delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSMutableArray*) listadoEventos{
    if (!_listadoEventos) {
        _listadoEventos = [[NSMutableArray alloc]init];
    }
    return  _listadoEventos;
}

- (void)reloadData {
    NSError *error = nil;
    
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Error fetching Eventos: %@", error.localizedDescription);
    }
    
    [self.tableView reloadData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[[self fetchedResultsController] sections] count];
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
    Evento *evento = [[self fetchedResultsController] objectAtIndexPath:indexPath];
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




- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Evento"];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@", @"gale"];
//    fetchRequest.predicate = predicate;
    fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.contexto sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}



-(void)cargaDatos{
    Evento *evento1 = [NSEntityDescription insertNewObjectForEntityForName:@"Evento" inManagedObjectContext:self.contexto];
    Evento *evento2 = [NSEntityDescription insertNewObjectForEntityForName:@"Evento" inManagedObjectContext:self.contexto];
    Evento *evento3 = [NSEntityDescription insertNewObjectForEntityForName:@"Evento" inManagedObjectContext:self.contexto];
    Evento *evento4 = [NSEntityDescription insertNewObjectForEntityForName:@"Evento" inManagedObjectContext:self.contexto];
    evento1.name = @"Centro Cultural La Corrala UAM";
    evento2.name = @"Fundación de los Ferrocarriles Españoles";
    evento3.name = @"Galería Alegría";
    evento4.name = @"Galería Arte 10";
    evento1.descripcion = @"Situado en el centro de la ciudad -en la histórica corrala de la calle de Carlos Arniches, en mitad de El Rastro-, La Corrala tiene por objetivo proyectar la creatividad y la capacidad de innovación científica de la Universidad Autónoma a todo Madrid.";
    evento2.descripcion = @"El Palacio de Fernán Núñez es la sede de la Fundación de los Ferrocarriles Españoles desde 1985. En el palacio se organizan exposiciones temporales.";
    evento3.descripcion = @"Apostamos por una programación en la que convivan artistas de corta, media y larga carrera con otros artistas absolutamente desconocidos fuera del circuito. La Galería Alegría es un espacio abierto al arte, al diseño y a todo aquello que nos interese y emocione";
    evento4.descripcion = @"En la Galería Arte 10, podrás encontrar expuesta básicamente obra gráfica moderna y contemporánea, esculturas, objetos y libros de artista. Realiza exposiciones tituladas y/o temáticas de la Colección Arte 10, pero ocasionalmente también de artistas del momento.";
    evento1.imagen = @"http://laventanadelarte.es/images/madrid/3874/foto-centro-2903142217318bb97c.jpg";
    evento2.imagen = @"http://laventanadelarte.es/images/madrid/3892/foto-centro-0204141839342818b4.jpg";
    evento3.imagen = @"http://laventanadelarte.es/images/madrid/3905/foto-centro-030414103516e1a1f2.jpg";
    evento4.imagen = @"http://laventanadelarte.es/images/madrid/3917/foto-centro-030414103849a3f68e.jpg";


    self.listadoEventos = [[NSMutableArray alloc]init];
    [self.listadoEventos addObject:evento1];
    [self.listadoEventos addObject:evento2];
    [self.listadoEventos addObject:evento3];
    [self.listadoEventos addObject:evento4];
    
    [self.contexto save:nil];
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
