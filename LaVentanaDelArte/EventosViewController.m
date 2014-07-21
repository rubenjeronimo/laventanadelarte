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
#import "DetalleViewController.h"
#import "MapViewController.h"
@interface EventosViewController () <NSFetchedResultsControllerDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *anchoToolBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *listadoEventos;
@property (nonatomic,strong) NSDictionary *evento;
@property (nonatomic,strong) NSArray *eventosFiltrados;
@property (nonatomic,strong) NSFetchRequest *eventosBusquedaFetchRequest;
@end
typedef enum
{
    searchScopeEvento = 0,
    searchScopeEspacio = 1
} EventoSearchScope;
@implementation EventosViewController {
    NSFetchedResultsController *_fetchedResultsController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}


- (NSFetchRequest *)eventosBusquedaFetchRequest
{
    if (_eventosBusquedaFetchRequest != nil)
    {
        return _eventosBusquedaFetchRequest;
    }
    
    _eventosBusquedaFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Evento" inManagedObjectContext:self.contexto];
    [_eventosBusquedaFetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [_eventosBusquedaFetchRequest setSortDescriptors:sortDescriptors];
    
    return _eventosBusquedaFetchRequest;
}
- (void)searchForText:(NSString *)searchText scope:(EventoSearchScope)scopeOption
{
    if (self.contexto)
    {
        NSString *predicateFormat = @"%K BEGINSWITH[cd] %@";
        NSString *searchAttribute = @"name";
        
        if (scopeOption == searchScopeEspacio)
        {
            searchAttribute = @"Evento";
        }
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, searchAttribute, searchText];
        [self.eventosBusquedaFetchRequest setPredicate:predicate];
        
        NSError *error = nil;
        self.eventosFiltrados = [self.contexto executeFetchRequest:self.eventosBusquedaFetchRequest error:&error];
    }
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    EventoSearchScope scopeKey = controller.searchBar.selectedScopeButtonIndex;
    [self searchForText:searchString scope:scopeKey];
    return YES;
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    NSString *searchString = controller.searchBar.text;
    [self searchForText:searchString scope:searchOption];
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    self.anchoToolBar.constant = self.view.frame.size.width;
    [self.tableView reloadData];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor = [UIColor grayColor];
    self.anchoToolBar.constant = self.view.frame.size.width;
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

- (IBAction)areaEstudio:(id)sender {
    UIActionSheet *as = [[UIActionSheet alloc]initWithTitle:@"Tipo de evento" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Exposicion",@"Todos", nil];
    [as showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            NSLog(@"Exposiciones");
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


-(void)tipo:(id)sender{
    NSLog(@"tipo ");
}

-(void)cercano:(id)sender{
    NSLog(@"cercano");
    MapViewController *mapView = [self.storyboard instantiateViewControllerWithIdentifier:@"MapView"];
    [self presentViewController:mapView animated:YES completion:nil];
    
}

/*
-(void)busca:(id)sender{
    NSLog(@"busca");
    
    
    CGRect frameVistaBusqueda =CGRectMake(self.view.frame.size.width/2 -150, self.view.frame.size.height/2 -150, 300, 100);
    
    UIView *vistaBusqueda = [[UIView alloc]initWithFrame:frameVistaBusqueda];
    vistaBusqueda.layer.cornerRadius = 20;
    CGRect frameBarraBusqueda = CGRectMake(frameVistaBusqueda.size.width/2-100,frameVistaBusqueda.size.height/2, 200, 30);
    UISearchBar *barraBusqueda = [[UISearchBar alloc]initWithFrame:frameBarraBusqueda];
    barraBusqueda.backgroundColor = [UIColor whiteColor];
    barraBusqueda.alpha = 1;
    barraBusqueda.placeholder = @"busca...";
    vistaBusqueda.backgroundColor = [UIColor colorWithRed:0.699 green:0.867 blue:0.535 alpha:0.7];
    [self.view addSubview:vistaBusqueda];
    [vistaBusqueda addSubview:barraBusqueda];
    [barraBusqueda resignFirstResponder];
}
*/

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
    self.eventosBusquedaFetchRequest = nil;
    [super didReceiveMemoryWarning];
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
    if (tableView == self.tableView)
    {
        NSInteger numberOfItems = 0;
        
        if ([self fetchedResultsController].sections.count > 0) {
            id<NSFetchedResultsSectionInfo> sectionInfo = [self fetchedResultsController].sections[section];
            numberOfItems = [sectionInfo numberOfObjects];
        }
        
        return numberOfItems;
    }

    else
    {
        return [self.eventosFiltrados count];
    }
    
}
    



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    VentanaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[VentanaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
//        cell.textLabel.text = self.eventosFiltrados[indexPath.row];
        Evento *evento = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        cell.NameEvento.text = evento.name;
        cell.typeEvento.text = evento.descripcion;
        NSURL *url = [NSURL URLWithString:evento.imagen];
        NSData *data = [NSData dataWithContentsOfURL:url];
        cell.ImageEvento.image = [UIImage imageWithData:data];
    } else {
//        cell.textLabel.text = self.listadoEventos[indexPath.row];
        Evento *evento = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        cell.NameEvento.text = evento.name;
        cell.typeEvento.text = evento.descripcion;
        NSURL *url = [NSURL URLWithString:evento.imagen];
        NSData *data = [NSData dataWithContentsOfURL:url];
        cell.ImageEvento.image = [UIImage imageWithData:data];
    }
    [cell reDibujaSerie];
    return cell;
   /*
    VentanaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
 //   VentanaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    Evento *evento = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    cell.NameEvento.text = evento.name;
    cell.typeEvento.text = evento.descripcion;
    NSURL *url = [NSURL URLWithString:evento.imagen];
    NSData *data = [NSData dataWithContentsOfURL:url];
    cell.ImageEvento.image = [UIImage imageWithData:data];
    return cell;
    */
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString: @"EventoSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
        DetalleViewController *detalleVC = [segue destinationViewController];
        Evento *evento = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        detalleVC.evento = evento;
    }
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Evento"];

    fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.contexto sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

//#pragma mark - ancho tool bar


@end
