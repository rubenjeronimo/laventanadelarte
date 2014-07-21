//
//  VentanaTableViewCell.h
//  LaVentanaDelArte
//
//  Created by Ruben Jeronimo Fernandez on 14/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VentanaTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *NameEvento;
@property (weak, nonatomic) IBOutlet UILabel *typeEvento;
@property (weak, nonatomic) IBOutlet UIImageView *ImageEvento;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopImageCell;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightImageCell;
-(void) reDibujaSerie;
@end
