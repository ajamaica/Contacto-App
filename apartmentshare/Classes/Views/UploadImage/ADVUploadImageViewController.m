//
//  ADVUploadImageViewController.m
//  apartmentshare
//
//  Created by Tope Abayomi on 22/01/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "ADVUploadImageViewController.h"
#import "ADVTheme.h"
#import "DetailsCell.h"
#import "AppDelegate.h"

#import <QuartzCore/QuartzCore.h>

typedef enum {
    LocationDetail,
    PriceDetail,
    RoomDetail,
    TypeDetail,
    TextDetail
} DetailIndex ;

@interface ADVUploadImageViewController ()

@end

@implementation ADVUploadImageViewController{
    PFFile* photo;
    CLLocation *location;
}

@synthesize locationManager;

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Subir";
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Enviar" style:UIBarButtonItemStylePlain target:self action:@selector(uploadTapped:)];
    
    id <ADVTheme> theme = [ADVThemeManager sharedTheme];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[theme viewBackground]]];
    
    [self.imageContainer.layer setBorderWidth:5];
    [self.imageContainer.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    [self.imageContainer.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.imageContainer.layer setShadowOffset:CGSizeMake(2, 2)];
    [self.imageContainer.layer setShadowOpacity:0.6];
    [self.imageContainer.layer setShadowRadius:5];
    
    [self.dataTableView setDataSource:self];
    [self.dataTableView setDelegate:self];
    
    self.descriptionTextField = [[UITextField alloc] initWithFrame:CGRectMake(130, 15, 175, 30)];
    [self.descriptionTextField setBackgroundColor:[UIColor clearColor]];
    [self.descriptionTextField setPlaceholder:@"Mini Cooper S"];
    [self.descriptionTextField setBorderStyle:UITextBorderStyleNone];
    [self.descriptionTextField setReturnKeyType:UIReturnKeyDone];
    [self.descriptionTextField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    self.locationTextField = [[UITextField alloc] initWithFrame:CGRectMake(130, 15, 175, 30)];
    [self.locationTextField setBackgroundColor:[UIColor clearColor]];
    [self.locationTextField setPlaceholder:@"Centro, Querétaro"];
    [self.locationTextField setBorderStyle:UITextBorderStyleNone];
    [self.locationTextField setReturnKeyType:UIReturnKeyDone];
    [self.locationTextField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    self.priceTextField = [[UITextField alloc] initWithFrame:CGRectMake(130, 15, 175, 30)];
    [self.priceTextField setBackgroundColor:[UIColor clearColor]];
    [self.priceTextField setPlaceholder:@"$1,500"];
    [self.priceTextField setBorderStyle:UITextBorderStyleNone];
    [self.priceTextField setReturnKeyType:UIReturnKeyDone];
    [self.priceTextField setKeyboardType:UIKeyboardTypeDecimalPad];
    [self.priceTextField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    /*
    self.roomsSlider = [[UISlider alloc] initWithFrame:CGRectMake(130, 15, 150, 30)];
    [self.roomsSlider setMaximumValue:7];
    [self.roomsSlider setMinimumValue:1];
    [self.roomsSlider setValue:2];
    [self.roomsSlider addTarget:self action:@selector(numberOfRoomsChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    self.roomsLabel = [[UILabel alloc] initWithFrame:CGRectMake(300, 12, 40, 30)];
    [self.roomsLabel setBackgroundColor:[UIColor clearColor]];
    [self.roomsLabel setTextColor:[UIColor darkGrayColor]];
    [self.roomsLabel setText:@"2"];
    */

    self.apartmentTypeControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Autos", @"Bienes",@"Varios" ,nil]];
    [self.apartmentTypeControl setFrame:CGRectMake(70, 15, 240, 44)];
    [self.apartmentTypeControl setSegmentedControlStyle:UISegmentedControlStylePlain];
    [self.apartmentTypeControl setSelectedSegmentIndex:0];

    
    self.textview = [[UITextView alloc] initWithFrame:CGRectMake(130, 15, 175, 100)];
    [self.textview.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [self.textview.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [self.textview.layer setBorderWidth: 1.0];
    [self.textview.layer setCornerRadius:8.0f];
    [self.textview.layer setMasksToBounds:YES];
    self.textview.delegate  = self;
    
    [self.navigationItem.rightBarButtonItem setEnabled:FALSE];
    
    if([[PFUser currentUser] objectForKey:@"location"]){
        [self.navigationItem.rightBarButtonItem setEnabled:TRUE];
    }else{
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        [locationManager startUpdatingLocation];

    }
    
    
    
       
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    location = newLocation;
    PFGeoPoint *p = [PFGeoPoint  geoPointWithLocation:location];
    PFUser *u = [PFUser currentUser];
    [u setObject:p forKey:@"location"];
    [u saveInBackground];
    [locationManager stopUpdatingLocation];
    
    [self.navigationItem.rightBarButtonItem setEnabled:TRUE];
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return TRUE;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return TRUE;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIImageView *imgBkg = [[UIImageView alloc] initWithImage:[[ADVThemeManager sharedTheme] tableSectionHeaderBackground]];
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 300, 22)];
    lblTitle.text = @"Detalles";
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor colorWithRed:0.43f green:0.43f blue:0.43f alpha:1.00f];
    lblTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0f];
    
    [imgBkg addSubview:lblTitle];
    return imgBkg;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    DetailsCell *cell = (DetailsCell*)[tableView dequeueReusableCellWithIdentifier:@"DetailsCell"];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list-element.png"]];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.row == LocationDetail){
    
        cell.detailLabel.text = @"Descripción";
        
        [cell addSubview:self.descriptionTextField];
    }
    else if(indexPath.row == PriceDetail){
    
        cell.detailLabel.text = @"Precio";
        
        [cell addSubview:self.priceTextField];
    }
    else if (indexPath.row == RoomDetail){
        
        cell.detailLabel.text = @"Ubicación";
        
        [cell addSubview:self.locationTextField];
    }

    else if (indexPath.row == TypeDetail){
        
        cell.detailLabel.text = @"Tipo";
        
        [cell addSubview:self.apartmentTypeControl];
        
    }else if(indexPath.row == TextDetail){
        cell.detailLabel.text = @"Detalles";
        [cell addSubview:self.textview];
        
    }
    
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 32.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if(indexPath.row == TypeDetail){
        
        return 65;
    }
    if(indexPath.row == TextDetail){
        
        return 130;
    }
    return 55.0f;
}



#pragma mark IB Actions
-(IBAction)numberOfRoomsChanged:(id)sender{
    
    [self.roomsLabel setText:[NSString stringWithFormat:@"%.0f", self.roomsSlider.value]];
}

-(IBAction)selectPicturePressed:(id)sender
{
    
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Selecciona una Fuente" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Galería", @"Cámara", nil];
    popupQuery.tag = 0;
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    [popupQuery showInView:self.view];
    
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        imgPicker.delegate = self;
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
        
    } else if (buttonIndex == 1) {
        
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        imgPicker.delegate = self;
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
        
    } else if (buttonIndex == 2) {
        
        
    } 
}


-(IBAction)uploadTapped:(id)sender
{    
    [self.textview resignFirstResponder];
    [self.priceTextField resignFirstResponder];
    [self.locationTextField resignFirstResponder];
    [self.descriptionTextField resignFirstResponder];
    
        
   
    
    if([self.descriptionTextField.text length] <= 0){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error."
                                                         message:@"Ingresa una descripción."
                                                        delegate:self
                                               cancelButtonTitle:@"Ok"
                                               otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    
    if([self.priceTextField.text length] <= 0){
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error."
                                                         message:@"Ingresa el Precio."
                                                        delegate:self
                                               cancelButtonTitle:@"Ok"
                                               otherButtonTitles:nil];
        
        [alert show];
        
        return;
    }

    if([self.locationTextField.text length] <= 0){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error."
                                                         message:@"Ingresa una zona."
                                                        delegate:self
                                               cancelButtonTitle:@"Ok"
                                               otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    
    
    
    PFObject *category;
    if([self.apartmentTypeControl selectedSegmentIndex] == 0){
        category = [PFObject objectWithoutDataWithClassName:@"Category" objectId:@"re5rF1jMkb"];
    }
    
    if([self.apartmentTypeControl selectedSegmentIndex] == 1){
        category = [PFObject objectWithoutDataWithClassName:@"Category" objectId:@"O30KnNmp2l"];
    }
    
    if([self.apartmentTypeControl selectedSegmentIndex] == 2){
        category = [PFObject objectWithoutDataWithClassName:@"Category" objectId:@"B5HNeL8Clg"];
    }
       
    PFObject *anuncio = [PFObject objectWithClassName:@"Anuncio"];
    [anuncio setObject:photo forKey:@"imagen"];
    [anuncio setObject:[NSNumber numberWithFloat:[self.priceTextField.text floatValue]] forKey:@"price"];
    [anuncio setObject:self.descriptionTextField.text forKey:@"title"];
    [anuncio setObject:category forKey:@"category"];
    [anuncio setObject:[PFUser currentUser] forKey:@"user"];
    [anuncio setObject:[NSNumber numberWithBool:NO] forKey:@"Vendido"];
    [anuncio setObject:self.locationTextField.text forKey:@"ubicacion"];
    [anuncio setObject:self.textview.text forKey:@"details"];
    if([[PFUser currentUser] objectForKey:@"location"]){
        
        PFGeoPoint *point = [PFGeoPoint geoPointWithLocation:location];
        [anuncio setObject:[[PFUser currentUser] objectForKey:@"location"] forKey:@"location"];
        
    }
    
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [activityIndicator startAnimating];
    
    JSNotifier *notify = [[JSNotifier alloc]initWithTitle:@"Subiendo..."];
    notify.accessoryView = activityIndicator;
    [notify show];
    [anuncio saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [notify hide];
        [[NSNotificationCenter defaultCenter] postNotificationName: @"reload" object:nil userInfo:nil];
        if(error){
            JSNotifier *notify = [[JSNotifier alloc]initWithTitle:@"No se logró subir la imagen..."];
            notify.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"NotifyX.png"]];
            [notify showFor:2.0];
        }
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark UIImagePicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo 
{
    
    [picker dismissModalViewControllerAnimated:YES];
    
    //Place the image in the imageview
    NSData * data = UIImageJPEGRepresentation(img, 0.4);
    [data writeToFile:@"foo.jpeg" atomically:YES];
    
    self.uploadImageView.image = img;
    
    photo = [PFFile fileWithName:@"image" data:data];
    
}

#pragma mark Error View


-(void)showErrorView:(NSString *)errorMsg
{
    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorAlertView show];
}

#define kOFFSET_FOR_KEYBOARD 205.0

- (BOOL)textFieldShouldReturn:(UITextField *)sender {
    [sender resignFirstResponder];
    return YES;
}

- (IBAction)textFieldFinished:(id)sender
{
    [sender resignFirstResponder];
}


-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:self.priceTextField] || [sender isEqual:self.locationTextField])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.textview resignFirstResponder];
    /*[self.priceTextField resignFirstResponder];
    [self.locationTextField resignFirstResponder];
    [self.descriptionTextField resignFirstResponder];*/
}
//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        //rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        //rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}



@end
