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
#import "MapViewController.h"
typedef NS_ENUM(NSUInteger, FilterType) {
    FilterTypeAll,
    FilterTypeArts
};
@interface EspaciosTableViewController () <NSFetchedResultsControllerDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UIActionSheetDelegate>
@property (nonatomic,strong) NSMutableArray *listadoEspacios;
@property (nonatomic,strong) NSDictionary *espacio;
@property (nonatomic,strong) NSMutableArray *listadoEventos;
@property (nonatomic,strong) NSDictionary *evento;
@property (nonatomic) FilterType currentFilter;
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

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
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
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    VentanaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[VentanaTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        Espacio *espacio = [[self fetchedResultsController]objectAtIndexPath:indexPath];
        cell.textLabel.text = espacio.nombre;
        cell.detailTextLabel.text = espacio.resumen;
        NSURL *url = [NSURL URLWithString:espacio.imagen];
        NSData *data = [NSData dataWithContentsOfURL:url];
        cell.imageView.image = [UIImage imageWithData:data];
    } else {
        Espacio *espacio = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        cell.NameEvento.text = espacio.nombre;
        cell.typeEvento.text = espacio.resumen;
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSString *foto = espacio.imagen;
            NSString *provincia = espacio.provincia_id;
            NSString *centro = [NSString stringWithFormat:@"%@", espacio.id_centro];
            NSString *fotoInicio = @"http://laventana.solytek.es/images";
            NSString *imString = [NSString stringWithFormat:@"%@/%@/%@/%@", fotoInicio, provincia, centro,foto];

            NSURL *url = [NSURL URLWithString:imString];
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

#pragma mark - segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString: @"DetalleSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
        DetalleViewController *detalleVC = [segue destinationViewController];
        Espacio *espacio = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        detalleVC.espacio = espacio;
    } else if ([segue.identifier isEqualToString:@"centroMapSegue"]){
        MapViewController *mapView = [segue destinationViewController];
        mapView.contexto = self.contexto;
        mapView.fetchedResultsController = [self fetchedResultsController];
        [mapView POI];
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

#pragma mark - fetchRequest

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Espacio"];
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@", @"gale"];
    //    fetchRequest.predicate = predicate;
    if (self.currentFilter == FilterTypeArts) {
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"tipo == %@", @(self.currentFilter)];
    }

    fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"nombre" ascending:YES]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.contexto sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}
- (IBAction)areaEstudio:(id)sender {
    UIActionSheet *as = [[UIActionSheet alloc]initWithTitle:@"Tipo de evento" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Arte Contemporaneo",@"Todos", nil];
    [as showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            self.currentFilter = FilterTypeArts;
            break;
        case 1:
            self.currentFilter = FilterTypeAll;
            break;
        default:
            break;
    }
    _fetchedResultsController = nil;
    [self reloadData];
}





@end


