//
//  SidebarCell.h
//  Contacto
//
//  Created by Arturo Jamaica Garcia on 16/02/13.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SidebarCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *uiimage;
@property (weak, nonatomic) IBOutlet UIView *notification;
@property (weak, nonatomic) IBOutlet UILabel *number;

@end
