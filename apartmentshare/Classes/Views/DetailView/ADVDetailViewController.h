//
//  ADVDetailViewController.h
//  apartmentshare
//
//  Created by Tope on 30/01/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApartmentSchema.h"
#import "JASidePanelController.h"
#import "ASMediaFocusManager.h"

@interface ADVDetailViewController : UIViewController<ASMediasFocusDelegate>

@property (strong, nonatomic) ASMediaFocusManager *mediaFocusManager;

@property (nonatomic, weak) IBOutlet UILabel* addressLabel;

@property (nonatomic, weak) IBOutlet UIImageView* apartmentImageView;

@property (nonatomic, strong) IBOutlet UIView* shadowView;

@property (nonatomic, weak) IBOutlet UIButton* contactButton;

@property (nonatomic, weak) IBOutlet UIView* moreDetailsView;

@property (nonatomic, weak) IBOutlet UITextView* moreDetailsTextView;

@property (nonatomic, strong) IBOutlet UIScrollView* scrollView;

@property (nonatomic, weak) IBOutlet UILabel* priceLabel;

@property (nonatomic, weak) IBOutlet UILabel* roomsLabel;

@property (nonatomic, weak) IBOutlet UILabel* apartmentTypeLabel;

@property (nonatomic, strong) PFObject* apartment;

@property (nonatomic, strong) UIImage* apartmentImage;

@end
