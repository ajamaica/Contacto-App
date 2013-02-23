//
//  ADVApartmentListViewController.m
//  apartmentshare
//
//  Created by Tope Abayomi on 22/01/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//


#import "ADVApartmentListViewController.h"
#import "ADVUploadImageViewController.h"
#import "ADVLoginViewController.h"
#import "ADVDetailViewController.h"
#import "ApartmentCell.h"
#import "AppDelegate.h"
#import "ApartmentSchema.h"
#import "ADVTheme.h"
#import "KGNoise.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"

@interface ADVApartmentListViewController () {
    NSNumber *latestDate;
    BOOL abierto;
    BOOL loading;
    NSArray *objects;
    PFObject *category;
    UIRefreshControl *refreshControl;
}

@property (nonatomic, retain) NSArray *apartments;
@property (nonatomic, retain) NSMutableDictionary *apartmentImages;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;


-(void)getAllApartments;
-(void)showErrorView:errorString;

@end

@implementation ADVApartmentListViewController{
    CLLocation *location;
}
@synthesize locationManager;
@synthesize searchResults;

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
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
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    abierto = FALSE;
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Tira para recargar."];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.apartmentTableView addSubview:refreshControl];
    
       
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenHeight = screenSize.height;
    CGFloat screenWidth = screenSize.width;

    [self.container setFrame:CGRectMake(0 - screenWidth, 0.0f, self.container.frame.size.width, self.container.frame.size.height)];
    
    //self.title = @"Apartments";

    id <ADVTheme> theme = [ADVThemeManager sharedTheme];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[theme viewBackground]]];
    
   
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Publicar" style:UIBarButtonItemStylePlain target:self action:@selector(uploadPressed:)];
    
    [self.apartmentTableView setDelegate:self];
    [self.apartmentTableView setDataSource:self];
    
    self.apartmentImages = [NSMutableDictionary dictionary];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}

- (void)handleRefresh:(id)sender
{
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Cargando..."];
    [self doquery];
}

- (void) receiveTestNotification:(NSNotification *) notification{
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    objects = [NSArray new];
    [self.apartmentTableView reloadData];
    
    NSDictionary *userInfo = notification.userInfo;
    category = [userInfo objectForKey:@"object"];
    
    if([[category objectId] isEqualToString:@"re5rF1jMkb"]){
        [self.title_btn setTitle:@"Autos ▾" forState:UIControlStateNormal];
    }
    
    if([[category objectId] isEqualToString:@"O30KnNmp2l"]){
        [self.title_btn setTitle:@"Bienes Raices ▾" forState:UIControlStateNormal];
    }
    
    if([[category objectId] isEqualToString:@"B5HNeL8Clg"]){
        [self.title_btn setTitle:@"Varios ▾" forState:UIControlStateNormal];
    }
    
    
    if([[category objectId] isEqualToString:@"ORqAwEdAtK"]){
        [self.title_btn setTitle:@"Listado ▾" forState:UIControlStateNormal];
        category = nil;
    }
    
    
    [self close];
    
    
    abierto = FALSE;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"close"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doquery)
                                                 name:@"reload"
                                               object:nil];

    
    [self.apartmentTableView setContentOffset:CGPointMake(0, 44)];
    [self.title_btn setTitle:@"Listado ▾" forState:UIControlStateNormal];
    // self.navigationItem.leftBarButtonItem.title = [self getLogText];
    
    searchResults = [NSMutableArray new];
    
    KGNoiseRadialGradientView *noiseView = [[KGNoiseRadialGradientView alloc] initWithFrame:self.view.frame];
    noiseView.backgroundColor = [UIColor colorWithRed:0.814 green:0.798 blue:0.747 alpha:1.000];
    noiseView.alternateBackgroundColor = [UIColor colorWithRed:1.000 green:0.986 blue:0.945 alpha:1.000];
    noiseView.noiseOpacity = 0.3;
    [self.view insertSubview:noiseView atIndex:0];
    
    
    loading = TRUE;
    [self doquery];
}


- (void)doquery{
    PFQuery *query = [PFQuery queryWithClassName:@"Anuncio"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    NSString *className = NSStringFromClass([self class]);
    if(category){
        [query whereKey:@"category" equalTo:category];
    }
    [query whereKey:@"Vendido" equalTo:[NSNumber numberWithBool:NO]];
    
    [query whereKey:@"Eliminado" notEqualTo:[NSNumber numberWithBool:YES]];
    [query includeKey:@"user"];
    
    if([className isEqualToString:@"MisAnunciosViewController"]){
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
    }
    
    if([[PFUser currentUser] objectForKey:@"location"]){
        PFGeoPoint *userGeoPoint = [[PFUser currentUser] objectForKey:@"location"];
        [query whereKey:@"location" nearGeoPoint:userGeoPoint withinKilometers:30.0];

    }
    
    [query orderByDescending:@"createdAt"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *obj, NSError *error) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            loading = FALSE;
            objects = obj;
            [self.apartmentTableView reloadData];
            [refreshControl endRefreshing];
        } else {
            
        }
    }];
    /*
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
     */
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([tableView
         isEqual:self.searchDisplayController.searchResultsTableView]){
        return [searchResults count];
    }
    
    if(loading){
        return 0;
    }
    return [objects count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    PFObject *anuncio;
    ApartmentCell* cell;
    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        
        anuncio =
        [searchResults objectAtIndex:indexPath.row];
         cell = [self.apartmentTableView dequeueReusableCellWithIdentifier:@"ApartmentCell" forIndexPath:indexPath];
        
    }
    else{
        anuncio = [objects objectAtIndex:indexPath.row];
        cell = [tableView dequeueReusableCellWithIdentifier:@"ApartmentCell" forIndexPath:indexPath];
    }
    
     
    
    if (cell == nil) {
        
        cell = [[ApartmentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ApartmentCell"] ;
        
    }
    
   
    
    cell.anuncio = anuncio;
    
    
   
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *priceString = [numberFormatter stringFromNumber:[anuncio objectForKey:@"price"]];
    
    PFGeoPoint *pf = [[PFUser currentUser] objectForKey:@"location"];
    
    float d= [pf distanceInKilometersTo: [anuncio objectForKey:@"location"]];
    NSString* roomCountText = [NSString stringWithFormat:@"%.02f Km", d];
    
    [cell.locationLabel setText:[anuncio objectForKey:@"title"]];
    [cell.priceLabel setText:priceString];
    [cell.roomsLabel setText:roomCountText];
   
    
    if([[[anuncio objectForKey:@"category"] objectId] isEqualToString:@"re5rF1jMkb"]){
        [cell.apartmentTypeLabel setText:@"Autos"];
    }
    
    if([[[anuncio objectForKey:@"category"] objectId] isEqualToString:@"O30KnNmp2l"]){
        [cell.apartmentTypeLabel setText:@"Bienes"];
    }
    
    if([[[anuncio objectForKey:@"category"] objectId] isEqualToString:@"B5HNeL8Clg"]){
        [cell.apartmentTypeLabel setText:@"Varios"];
    }
    cell.name.text = [[anuncio objectForKey:@"user"] objectForKey:@"username"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    

    
    PFFile *file = [anuncio objectForKey:@"imagen"];
    
    [cell.apartmentImageView setImageWithURL:[NSURL URLWithString:[file url]] placeholderImage:[UIImage imageNamed:@"apartment-1.jpg"]];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

#pragma mark - UISearchDisplayController delegate methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    [controller.searchResultsTableView registerClass:[ApartmentCell class] forCellReuseIdentifier:@"ApartmentCell"];
    
    
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text]
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:searchOption]];
    
    return YES;
}


- (void)filterContentForSearchText:(NSString*)searchText
                             scope:(NSString*)scope
{
    searchResults = [NSMutableArray new];
    if([searchText length]>2){
        for (PFObject *obj in objects) {
            NSRange rangeValue = [[obj objectForKey:@"title"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(rangeValue.length > 0){
                [searchResults addObject:obj];
            }
        }
    }
    
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 260;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"detail" sender:self];
}

#pragma mark Receive Wall Objects




#pragma mark IB Actions
-(IBAction)uploadPressed:(id)sender
{
    [self performSegueWithIdentifier:@"upload" sender:self];
}


-(IBAction)loginLogoutPressed:(id)sender
{
    if([self appDelegate].isLoggedIn){
    
        [self appDelegate].isLoggedIn = NO;
        self.navigationItem.leftBarButtonItem.title = [self getLogText];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (IBAction)pressnavbar:(id)sender {
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenHeight = screenSize.height;
    CGFloat screenWidth = screenSize.width;
    
    if(abierto == FALSE){
        
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: nil
                     animations:^{
                         [self.apartmentTableView setFrame:CGRectMake(0.0f, screenHeight, self.apartmentTableView.frame.size.width, self.apartmentTableView.frame.size.height)];
                     }
                     completion:^ (BOOL finished)
     {
         if (finished) {
             [UIView animateWithDuration:0.3f
                                   delay:0.0f
                                 options: nil
                              animations:^{
                                  [self.container setFrame:CGRectMake(0.0f, 0.0f, self.container.frame.size.width, self.container.frame.size.height)];
                              }
                              completion:nil];
         }
     }];
        abierto = TRUE;
    }else{
        
        [self close];
        abierto = FALSE;
    }
}

-(void)close{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenHeight = screenSize.height;
    CGFloat screenWidth = screenSize.width;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: nil
                     animations:^{
                         [self.apartmentTableView setFrame:CGRectMake(0.0f, 0.0f, self.apartmentTableView.frame.size.width, self.apartmentTableView.frame.size.height)];
                     }
                     completion:^ (BOOL finished)
     {
         if (finished) {
             [UIView animateWithDuration:0.0f
                                   delay:0.0f
                                 options: nil
                              animations:^{
                                  [self.container setFrame:CGRectMake(0.0- screenWidth, 0.0f, self.container.frame.size.width, self.container.frame.size.height)];
                              }
                              completion:^(BOOL finished){
                                  [self doquery];
                              }];
         }
     }];
}
-(NSString*)getLogText{
    
    NSString* logText = [self appDelegate].isLoggedIn ? @"Log Out" : @"Log In";
    
    return logText;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"detail"]){
 
        ADVDetailViewController* detail = (ADVDetailViewController*)segue.destinationViewController;
        detail.navigationItem.rightBarButtonItem =nil;
        NSIndexPath* indexPath = [self.apartmentTableView indexPathForSelectedRow];
        PFObject *apartment =[objects objectAtIndex:indexPath.row];
        
        detail.apartment = apartment;
        
       

    }
}

#pragma mark Error Alert

-(void)showErrorView:(NSString *)errorMsg{
    
    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorAlertView show];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
