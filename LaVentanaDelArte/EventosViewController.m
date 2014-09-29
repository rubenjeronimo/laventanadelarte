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
#import "MapasViewController.h"

typedef NS_ENUM(NSUInteger, FilterType) {
    FilterTypeAll,
    FilterTypeArts
};

@interface EventosViewController () <NSFetchedResultsControllerDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *anchoToolBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *altoToolBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightTipoButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMapButtonConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *listadoEventos;
@property (nonatomic,strong) NSDictionary *evento;
@property (nonatomic,strong) NSArray *eventosFiltrados;
@property (nonatomic,strong) NSFetchRequest *eventosBusquedaFetchRequest;
@property (nonatomic) FilterType currentFilter;
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
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", searchText];
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
    [self reDibujaToolBar];
}

-(void) reDibujaToolBar{
    
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
    self.altoToolBar.constant = 45;
    self.topTableView.constant = -10;
    self.leftMapButtonConstraint.constant = self.view.frame.size.width/4;
    self.rightTipoButtonConstraint.constant = self.view.frame.size.width/4;
    [CATransaction commit];
    
}

-(void) setPortait{
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.1];
    self.altoToolBar.constant = 65;
    self.topTableView.constant = 0;
    self.leftMapButtonConstraint.constant = self.view.frame.size.width/6;
    self.rightTipoButtonConstraint.constant = self.view.frame.size.width/6;
    [CATransaction commit];
    
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
    [self reDibujaToolBar];

}

- (IBAction)areaEstudio:(id)sender {
    UIActionSheet *as = [[UIActionSheet alloc]initWithTitle:@"Tipo de evento" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Arte Contemporaneo",@"Todos", nil];
    [as showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            NSLog(@"Exposiciones");
            self.currentFilter = FilterTypeArts;
            break;
        case 1:
            NSLog(@"Todos");
            self.currentFilter = FilterTypeAll;
            break;
        default:
            break;
    }

    _fetchedResultsController = nil;
    [self reloadData];

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
//    NSError *error = nil;
//    
//    if (![[self fetchedResultsController] performFetch:&error]) {
//        NSLog(@"Error fetching Eventos: %@", error.localizedDescription);
//    }
//    
//    [self.tableView reloadData];
    
}

#pragma mark - Table View Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        return [[[self fetchedResultsController] sections] count];
    }
    
    return 1; // filtered events
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
        cell = [[VentanaTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        Evento *evento = self.eventosFiltrados[indexPath.row];
        cell.textLabel.text = evento.nombre;
        cell.detailTextLabel.text = evento.descripcion;
        NSURL *url = [NSURL URLWithString:evento.foto];
        NSData *data = [NSData dataWithContentsOfURL:url];
        cell.imageView.image = [UIImage imageWithData:data];
    } else {
        Evento *evento = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        cell.NameEvento.text = evento.nombre;
        cell.typeEvento.text = evento.descripcion;
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{

            NSURL *url = [NSURL URLWithString:evento.foto];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];

            dispatch_sync(dispatch_get_main_queue(), ^{
                VentanaTableViewCell *destcell = (VentanaTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                if (destcell) {
                    destcell.ImageEvento.image = image;
                }
            });

        });
        
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView != self.tableView) {
        NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
        DetalleViewController *detalleVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detalleStoryboard"];
        Evento *evento = [[self eventosFiltrados] objectAtIndex:indexPath.row];
        detalleVC.evento = evento;
        
        [[self navigationController] pushViewController:detalleVC animated:YES];
        
    }
}


#pragma mark - Segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString: @"EventoSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
        DetalleViewController *detalleVC = [segue destinationViewController];
        Evento *evento = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        detalleVC.evento = evento;
    }
    else if ([segue.identifier isEqualToString:@"eventoMapaSegue"]){
        MapViewController *mapView = [segue destinationViewController];
        mapView.contexto = self.contexto;
        [mapView POI];
    }
}

#pragma mark - Fetched Result Controller

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Evento"];
    if (self.currentFilter == FilterTypeArts) {
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"tipo == %@", @(self.currentFilter)];
    }
    fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.contexto sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

//#pragma mark - ancho tool bar


- (IBAction)mapView:(id)sender {
    MapasViewController *mapasVC = [self.storyboard instantiateViewControllerWithIdentifier:@"vistaMapaStoryboard"];
    [self.navigationController pushViewController:mapasVC animated:YES];
}


@end
