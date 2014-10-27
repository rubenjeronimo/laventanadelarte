//
//  EventosViewController.h
//  LaVentanaDelArte
//
//  Created by Ruben Jeronimo Fernandez on 16/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import <UIKit/UIKit.h>
@class addData;
@interface EventosViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSManagedObjectContext *contexto;
@property (nonatomic,strong) addData *loadingData;
- (CAGradientLayer*) blueGradient;
@end
