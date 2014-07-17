//
//  addData.m
//  LaVentanaDelArte
//
//  Created by Ruben Jeronimo Fernandez on 17/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import "addData.h"
#import "Evento.h"
@interface addData()
@property (nonatomic,strong) NSDictionary *evento;
@end
@implementation addData
-(void) takeDataEventos{
    NSString *string = @"https://www.kimonolabs.com/api/eennv4bk?apikey=tjx9PaZRwpncvzd4YG9QBCEzD0bDWFgr";
    NSURL *urlEvento = [NSURL URLWithString:string];
    NSURLRequest *consultaEvento = [NSURLRequest requestWithURL:urlEvento];
    
    AFHTTPRequestOperation *operacion = [[AFHTTPRequestOperation alloc]initWithRequest:consultaEvento];
    operacion.responseSerializer = [AFJSONResponseSerializer serializer];
    [operacion setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.evento = (NSDictionary *)responseObject;
        NSArray *listadoTemporal = [self.evento valueForKeyPath:@"results.collection1"];
        for (NSDictionary *eve in listadoTemporal) {
            
            NSString *name = [eve valueForKeyPath:@"nombreExpo.text"];
            Evento *ev = [self eventoByName:name];
            
            if (!ev) {
                ev= [NSEntityDescription insertNewObjectForEntityForName:@"Evento" inManagedObjectContext:self.contexto];
            }
            
            @try {
                ev.name = [eve valueForKeyPath:@"nombreExpo.text"];
                ev.descripcion = [eve valueForKeyPath:@"detalleExpo.text"];
                ev.imagen =[eve valueForKeyPath:@"imagenExpo.src"];
            }
            @catch (NSException *exception) {
                NSLog(@"Exception: %@", exception);
                [ev.managedObjectContext deleteObject:ev];
            }
        }
        
        [self.contexto performBlock:^{
            NSError * error = nil;
            if (![self.contexto save:&error]) {
                NSLog(@"Error saving context: %@", error.localizedDescription);
            }
        }];
        
      //  [self reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"events loaded" object:self];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"que mal");
    }];
    [operacion start];
}

- (Evento *)eventoByName:(NSString *)name {
    NSError * error = nil;
    
    NSManagedObjectModel *model = self.contexto.persistentStoreCoordinator.managedObjectModel;
    NSDictionary *mappings = @{@"NAME":name};
    
    NSFetchRequest *request = [model fetchRequestFromTemplateWithName:@"eventosByName" substitutionVariables:mappings];
    NSArray *result = [self.contexto executeFetchRequest:request error:&error];
    if (!result) {
        NSLog(@"Error fetching eventos with name (%@): %@", name, error.localizedDescription);
        return nil;
    }
    return [result firstObject];
}
@end
