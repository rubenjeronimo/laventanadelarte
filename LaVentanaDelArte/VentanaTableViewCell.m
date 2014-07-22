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
    [self setImage];
}

-(void)setImage{
    self.ImageEvento.layer.cornerRadius = self.ImageEvento.frame.size.width/2;
    self.ImageEvento.clipsToBounds = YES;
}

-(void)setBackground{
    UIColor *colorOne = [UIColor colorWithWhite:0.9 alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.85 alpha:1.0];
    UIColor *colorThree     = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.7 alpha:1.0];
    UIColor *colorFour = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.4 alpha:1.0];
                         
    NSArray *colores =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, colorThree.CGColor, colorFour.CGColor, nil];
                         
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:0.6];
    NSNumber *stopThree = [NSNumber numberWithFloat:0.99];
    NSNumber *stopFour = [NSNumber numberWithFloat:1.0];
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, stopThree, stopFour, nil];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
                         gradientLayer.colors = colores;
                         gradientLayer.locations = locations;
    
    CALayer *layer = [CALayer layer];
    
    layer.backgroundColor = [UIColor colorWithRed:0.1 green:0.2 blue:0.1 alpha:0.7].CGColor;
    
    gradientLayer.cornerRadius = 10;
    gradientLayer.frame = CGRectInset(self.layer.frame, 5, 5);
    [self.layer insertSublayer:gradientLayer atIndex:0];
}

-(void) reDibujaSerie{
    
    UIDeviceOrientation orientacion = [[UIDevice currentDevice]orientation];
    
    if (orientacion==UIDeviceOrientationPortrait || orientacion==UIDeviceOrientationUnknown) {
        [self setPortait];
        
    }else if (orientacion == UIDeviceOrientationLandscapeLeft || orientacion == UIDeviceOrientationLandscapeRight){
        [self setLandscape];
    }
}


-(void) setLandscape{
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.1];
    CALayer *layer = [self.layer.sublayers objectAtIndex:0];
    layer.frame = CGRectInset(self.bounds, 5, 2.5);
    self.TopImageCell.constant = 11;
    self.rightImageCell.constant = 8;
    self.rightSpacesImageConstraint.constant = 8;
    [CATransaction commit];
    
}

-(void) setPortait{
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.1];
    CALayer *layer = [self.layer.sublayers objectAtIndex:0];
    layer.frame = CGRectInset(self.bounds, 5, 2.5);
    self.TopImageCell.constant = 11;
    self.rightImageCell.constant = 8;
    self.rightSpacesImageConstraint.constant = 8;
    [CATransaction commit];
    
}

-(void)prepareForReuse{
    [super prepareForReuse];
    self.NameEvento.text=nil;
    self.typeEvento.text=nil;
    self.ImageEvento.image = nil;
    
}


//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
