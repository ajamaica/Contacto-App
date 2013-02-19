//
//  ADVUploadImageViewController.h
//  apartmentshare
//
//  Created by Tope Abayomi on 22/01/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>

@protocol ADVUploadImageViewControllerDelegate
@required
- (void)locationUpdate:(CLLocation *)location; // Our location updates are sent here
- (void)locationError:(NSError *)error; // Any errors are sent here
@end

@interface ADVUploadImageViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate,UITextViewDelegate,UIActionSheetDelegate,CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
}

@property (nonatomic, retain) CLLocationManager *locationManager;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, weak) IBOutlet UIImageView *uploadImageView;

@property (nonatomic, weak) IBOutlet UIView *imageContainer;

@property (nonatomic, weak) IBOutlet UIButton *imageButton;

@property (nonatomic, weak) IBOutlet UITableView *dataTableView;

@property (nonatomic, strong) IBOutlet UITextField *locationTextField;

@property (nonatomic, strong) IBOutlet UITextField *descriptionTextField;

@property (nonatomic, strong) IBOutlet UITextView *textview;

@property (nonatomic, strong) IBOutlet UITextField *priceTextField;

@property (nonatomic, strong) IBOutlet UISlider *roomsSlider;

@property (nonatomic, strong) IBOutlet UILabel *roomsLabel;

@property (nonatomic, strong) IBOutlet UISegmentedControl *apartmentTypeControl;

@property (nonatomic, strong) NSError* uploadError;

-(IBAction)selectPicturePressed:(id)sender;



@end
