//
//  ADVApartmentListViewController.h
//  apartmentshare
//
//  Created by Tope Abayomi on 22/01/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface ADVApartmentListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,CLLocationManagerDelegate>
@property (nonatomic, retain) CLLocationManager *locationManager;

@property (nonatomic, copy) NSMutableArray *searchResults;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *navbar_btn;
@property (nonatomic, weak) IBOutlet UITableView *apartmentTableView;

-(IBAction)uploadPressed:(id)sender;
-(IBAction)loginLogoutPressed:(id)sender;
- (IBAction)pressnavbar:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIButton *title_btn;


@end
