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
    CALayer *layer = [CALayer layer];
    
    
//    UIImage *imagen = self.ImageEvento.image;
//    CIImage *blurImagen = [CIImage imageWithCGImage:imagen.CGImage];
//    CIFilter *gaussiano = [CIFilter filterWithName:@"CIGaussianBlur"];
//    [gaussiano setValue:blurImagen forKey:@"Input Image"];
//    [gaussiano setValue:[NSNumber numberWithFloat: 10] forKey: @"inputRadius"]; //change number to increase/decrease blur
//    CIImage *resultImage = [gaussiano valueForKey: @"outputImage"];
//    
//    //create UIImage from filtered image
//    blurImagen = [[[UIImage alloc] initWithCIImage:resultImage]CIImage];
    
    
    
    
    layer.backgroundColor = [UIColor colorWithRed:0.1 green:0.2 blue:0.1 alpha:0.7].CGColor;
    
    layer.cornerRadius = 20;
    layer.frame = CGRectInset(self.layer.frame, 5, 5);
    [self.layer insertSublayer:layer atIndex:0];
}
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
