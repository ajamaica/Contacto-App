//
//  ApartmentCell.m
//  apartmentshare
//
//  Created by Tope on 25/01/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "ApartmentCell.h"
#import <QuartzCore/QuartzCore.h>
#import "ADVApartmentListViewController.h"

@implementation ApartmentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

-(void)del{
    
    
    [self.anuncio setObject:[NSNumber numberWithBool:YES] forKey:@"Eliminado"];
    [self.anuncio saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error){
            [[NSNotificationCenter defaultCenter] postNotificationName: @"reload" object:nil userInfo:nil];
        }
    }];

    

}

-(void)vend{
    
    [self.anuncio setObject:[NSNumber numberWithBool:YES] forKey:@"Vendido"];
    [self.anuncio saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error){
            [[NSNotificationCenter defaultCenter] postNotificationName: @"reload" object:nil userInfo:nil];
        }
    }];    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [self.remover addTarget:self action:@selector(del) forControlEvents:UIControlEventTouchUpInside];
    [self.vendido addTarget:self action:@selector(vend) forControlEvents:UIControlEventTouchUpInside];
    if(!self.laidOut){
        
        CAGradientLayer *l = [CAGradientLayer layer];
        l.frame = self.shadowView.bounds;
        UIColor* startColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        UIColor* endColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        l.colors = [NSArray arrayWithObjects:(id)startColor.CGColor, (id)endColor.CGColor, nil];
        [self.shadowView.layer addSublayer:l];
        
        CAGradientLayer *topShadow = [CAGradientLayer layer];
        topShadow.frame = CGRectMake(0, -3, 320, 3);
        UIColor* startColor2 = [UIColor colorWithWhite:0.0 alpha:0.0];
        UIColor* endColor2 = [UIColor colorWithWhite:0.0 alpha:0.1];
        topShadow.colors = [NSArray arrayWithObjects:(id)startColor2.CGColor, (id)endColor2.CGColor, nil];
        [self.layer addSublayer:topShadow];
        
        self.laidOut = YES;
        
    }
}

@end
