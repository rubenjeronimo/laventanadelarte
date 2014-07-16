//
//  EventosTableView.h
//  LaVentanaDelArte
//
//  Created by Ruben Jeronimo Fernandez on 16/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventosTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSManagedObjectContext *contexto;

@end
