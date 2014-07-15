//
//  VentanaTableViewCell.m
//  LaVentanaDelArte
//
//  Created by Ruben Jeronimo Fernandez on 14/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import "VentanaTableViewCell.h"

@implementation VentanaTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [self setBackground];
}


-(void)setBackground{
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = [UIColor colorWithRed:0.731 green:0.441 blue:0.14 alpha:0.5].CGColor;
    layer.cornerRadius = 20;
    [self.layer insertSublayer:layer atIndex:0];
}
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
