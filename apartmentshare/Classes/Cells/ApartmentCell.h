//
//  ApartmentCell.h
//  apartmentshare
//
//  Created by Tope on 25/01/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApartmentCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel* locationLabel;

@property (nonatomic, strong) IBOutlet UILabel* priceLabel;

@property (nonatomic, strong) IBOutlet UILabel* roomsLabel;

@property (nonatomic, strong) IBOutlet UILabel* apartmentTypeLabel;

@property (nonatomic, strong) IBOutlet UIImageView* apartmentImageView;

@property (nonatomic, strong) IBOutlet UIView* shadowView;

@property (weak, nonatomic) IBOutlet UIButton *remover;

@property (nonatomic, assign) PFObject *anuncio;

@property (nonatomic, assign)  BOOL laidOut;

@property (weak, nonatomic) IBOutlet UIButton *vendido;

@end
