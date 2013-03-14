//
//  TiendaViewController.h
//  Contacto
//
//  Created by Arturo Jamaica Garcia on 01/03/13.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "ADVApartmentListViewController.h"
#import "AGMedallionView.h"

@interface TiendaViewController : ADVApartmentListViewController
@property (weak, nonatomic) IBOutlet AGMedallionView *logo;
@property (weak, nonatomic) IBOutlet MKMapView *mapview;
@property (weak, nonatomic) IBOutlet UILabel *lugarlabel;
@property (strong, nonatomic) IBOutlet PFObject *tienda;


@end
