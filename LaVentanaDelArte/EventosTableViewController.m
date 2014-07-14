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
@interface EventosTableViewController ()
@property (nonatomic,strong) NSArray *listadoEventos;
//@property (nonatomic,strong)NSDictionary *evento;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.listadoEventos = @[@{name:@"expo 1",space:@"museo coconut"},@{name:@"expo 2",space:@"museo otro"}];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [self.listadoEventos count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VentanaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *event = [self.listadoEventos objectAtIndex:indexPath.row];
    cell.NameEvento.text = [event objectForKey:name];
    cell.typeEvento.text = [event objectForKey:space];

    return cell;
}


//1.definir FetchresultController, 2.añadir observador al modelo, 3.cargar los datos cuando esté listo

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString: @"DetalleSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        DetalleViewController *detalleVC = [segue destinationViewController];
        NSDictionary *evento = [self.listadoEventos objectAtIndex:indexPath.row];
        NSString *tituloVC = [evento objectForKey:@"name"];
        NSString *textDetailVC = [evento objectForKey:@"detail"];
        NSString *latitudVC = [evento objectForKey:@"latitude"];
        NSString *longitudVC = [evento objectForKey:@"longitude"];
        NSString *urlVC = [evento objectForKey:@"url"];
        detalleVC.nombreString = tituloVC;
        detalleVC.detalleString = textDetailVC;
        detalleVC.urlString = urlVC;
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
