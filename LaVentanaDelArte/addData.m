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
@property (nonatomic,strong) NSDictionary *evento;
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
        self.evento = (NSDictionary *)responseObject;
//        NSArray *listadoTemporal = [self.evento valueForKeyPath:@"exposiciones"];
        for (NSDictionary *eve in self.evento) {
            
            NSString *nombre = [eve valueForKeyPath:@"nombre"];
            Evento *ev = [self eventoByName:nombre];
            
            if (!ev) {  
                ev= [NSEntityDescription insertNewObjectForEntityForName:@"Evento" inManagedObjectContext:self.contexto];
            }
            

                ev.nombre = [eve valueForKeyPath:@"nombre"];
                ev.resumen = [eve valueForKeyPath:@"resumen"];
                ev.foto =[eve valueForKeyPath:@"foto"];
                ev.tipo_expo = [eve valueForKey:@"tipo_expo"];
                ev.provincia_id = [eve valueForKey:@"provincia_id"];
                ev.id_centro = [eve valueForKey:@"id_centro"];
                ev.id_expo = [eve valueForKey:@"id"];

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
            NSString *name = [eve valueForKeyPath:@"nombre"];
            Espacio *esp = [self espacioByName:name];
            if (!esp) {
                esp=[NSEntityDescription insertNewObjectForEntityForName:@"Espacio" inManagedObjectContext:self.contexto];
            }
//            @try {
                esp.nombre = [eve valueForKeyPath:@"nombre"];
                esp.resumen = [eve valueForKeyPath:@"resumen"];
//                esp.imagen =[eve valueForKeyPath:@"imagen"];
                esp.cod_tipo = [eve valueForKey:@"cod_tipo"];
//                esp.latitud = [NSNumber numberWithFloat:[self randomFloatBetween:40.39 and:40.41]];
//                esp.longitud= [NSNumber numberWithFloat:[self randomFloatBetween:-3.71 and:-3.68]];
//            }
//            @catch (NSException *exception) {
//                NSLog(@"Exception: %@", exception);
//                [esp.managedObjectContext deleteObject:esp];
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
