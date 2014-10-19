//
//  addData.m
//  LaVentanaDelArte
//
//  Created by Ruben Jeronimo Fernandez on 17/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import "addData.h"
#import "Evento.h"
#import "Espacio.h"

@interface addData()
@property (nonatomic,strong) NSArray *evento;
@property (nonatomic,strong) NSDictionary *espacio;
@end
@implementation addData


-(void) takeDataEventos{
    NSString *string = @"http://laventana.solytek.es/phpconsultaEXPOSICIONESiOS.php";
    NSURL *urlEvento = [NSURL URLWithString:string];
    NSURLRequest *consultaEvento = [NSURLRequest requestWithURL:urlEvento];
    
    AFHTTPRequestOperation *operacion = [[AFHTTPRequestOperation alloc] initWithRequest:consultaEvento];
    operacion.responseSerializer = [AFJSONResponseSerializer serializer];
//    operacion.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [operacion setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.evento = (NSArray *)responseObject;
        //        NSArray *listadoTemporal = [self.evento valueForKeyPath:@"exposiciones"];
        for (NSDictionary *eve in self.evento) {
            
            NSString *nombre = [eve valueForKeyPath:@"nombre"];
            Evento *ev = [self eventoByName:nombre];
            
            if (!ev) {
                ev= [NSEntityDescription insertNewObjectForEntityForName:@"Evento" inManagedObjectContext:self.contexto];
            }
            
            
            ev.nombre = [eve objectForKey:@"nombre"];
            ev.resumen = [eve objectForKey:@"resumen"];
            ev.foto =[eve objectForKey:@"foto"];
            ev.tipo_expo = [eve objectForKey:@"tipo_expo"];
            ev.provincia_id = [eve objectForKey:@"provincia_id"];
            ev.id_centro = [eve objectForKey:@"id_centro"];
            ev.centro = [eve objectForKey:@"centro"];
            ev.id_expo = [eve objectForKey:@"id"];
            
            
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
        NSLog(@"%@", error.localizedDescription);
        
        
    }];
    [operacion start];
}

- (Evento *)eventoByName:(NSString *)nombre {
    NSError * error = nil;
    
    NSManagedObjectModel *model = self.contexto.persistentStoreCoordinator.managedObjectModel;
    NSDictionary *mappings = @{@"nombre":nombre};
    
    NSFetchRequest *request = [model fetchRequestFromTemplateWithName:@"eventosByName" substitutionVariables:mappings];
    NSArray *result = [self.contexto executeFetchRequest:request error:&error];
    if (!result) {
        NSLog(@"Error fetching eventos with name (%@): %@", nombre, error.localizedDescription);
        return nil;
    }
    return [result firstObject];
}

-(void) takeDataEspacios{
    NSString *string = @"http://laventana.solytek.es/phpconsultaCENTROSiOS.php";
    NSURL *urlEspacio = [NSURL URLWithString:string];
    NSURLRequest *consultaEvento = [NSURLRequest requestWithURL:urlEspacio];
    
    
    
    AFHTTPRequestOperation *operacion = [[AFHTTPRequestOperation alloc]initWithRequest:consultaEvento];
    operacion.responseSerializer = [AFJSONResponseSerializer serializer];
    [operacion setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.espacio = (NSDictionary *)responseObject;
        //        NSArray *listadoTemporal = [self.espacio valueForKeyPath:@"results.Lavapies"];
        for (NSDictionary *eve in self.espacio) {
            NSString *name = [eve objectForKey:@"nombre"];
            Espacio *esp = [self espacioByName:name];
            if (!esp) {
                esp=[NSEntityDescription insertNewObjectForEntityForName:@"Espacio" inManagedObjectContext:self.contexto];
            }
            
            esp.nombre = [eve objectForKey:@"nombre"];
            esp.resumen = [eve objectForKey:@"resumen"];
            esp.imagen =[eve objectForKey:@"foto"];
            esp.cod_tipo = [eve objectForKey:@"cod_tipo"];
            esp.id_centro = [eve objectForKey:@"id"];
            esp.provincia_id = [eve objectForKey:@"provincia_id"];
            esp.web = [eve objectForKey:@"web"];
            esp.tipologia = [eve objectForKey:@"tipologia"];
            esp.direccion = [eve objectForKey:@"direccion"];
            esp.nombre_id = @"TEST";
            //                esp.latitud = [NSNumber numberWithFloat:[self randomFloatBetween:40.39 and:40.41]];
            //                esp.longitud= [NSNumber numberWithFloat:[self randomFloatBetween:-3.71 and:-3.68]];
            //            }

       }
        
        [self.contexto performBlock:^{
            NSError * error = nil;
            if (![self.contexto save:&error]) {
                NSLog(@"Error saving context: %@", error.localizedDescription);
            }
        }];
        
        //[self reloadData];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"spaces loaded" object:self];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"que mal");
    }];
    [operacion start];
}

- (Espacio *)espacioByName:(NSString *)name {
    NSError * error = nil;
    
    NSManagedObjectModel *model = self.contexto.persistentStoreCoordinator.managedObjectModel;
    NSDictionary *mappings = @{@"nombre":name};
    
    NSFetchRequest *request = [model fetchRequestFromTemplateWithName:@"espaciosByName" substitutionVariables:mappings];
    NSArray *result = [self.contexto executeFetchRequest:request error:&error];
    if (!result) {
        NSLog(@"Error fetching eventos with name (%@): %@", name, error.localizedDescription);
        return nil;
    }
    return [result firstObject];
}

- (CGFloat)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

@end
