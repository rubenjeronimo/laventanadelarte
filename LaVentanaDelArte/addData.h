//
//  addData.h
//  LaVentanaDelArte
//
//  Created by Ruben Jeronimo Fernandez on 17/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
@class Evento;
@interface addData : NSObject
@property (nonatomic,strong) NSManagedObjectContext *contexto;
-(void) takeDataEventos;
- (Evento *)eventoByName:(NSString *)name;
@end
