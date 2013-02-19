//
//  MensajesCell.h
//  Contacto
//
//  Created by Arturo Jamaica Garcia on 16/02/13.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MensajesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imagen;
@property (weak, nonatomic) IBOutlet UILabel *titulo;
@property (weak, nonatomic) IBOutlet UILabel *description;

@end
