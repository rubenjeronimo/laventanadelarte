//
//  EventosTableViewController.h
//  LaVentanaDelArte
//
//  Created by Ruben Jeronimo Fernandez on 11/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EspaciosTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) UIManagedDocument *miModelo;
@property (nonatomic,strong) NSManagedObjectContext *contexto;

@end
