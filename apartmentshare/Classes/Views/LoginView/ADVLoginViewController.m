//
//  ADVLoginViewController.m
//  apartmentshare
//
//  Created by Tope Abayomi on 22/01/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "ADVLoginViewController.h"
#import "ADVRegisterViewController.h"
#import "ADVApartmentListViewController.h"
#import "ADVTheme.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@implementation ADVLoginViewController

@synthesize userTextField = _userTextField, passwordTextField = _passwordTextField;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize client = _client;

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Log In";
    }
    return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    id <ADVTheme> theme = [ADVThemeManager sharedTheme];
    
    
    self.title = @"Login";
    
    self.loginTableView = [[UITableView alloc] initWithFrame:CGRectMake(16, 50, 294, 110) style:UITableViewStyleGrouped];
    
    
    
    [self.loginTableView setScrollEnabled:NO];
    [self.loginTableView setBackgroundView:nil];
    [self.view addSubview:self.loginTableView];
    
    [self.loginTableView setDataSource:self];
    [self.loginTableView setDelegate:self];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[theme viewBackground]]];
    
    
    [self.loginButton setBackgroundImage:[theme colorButtonBackgroundForState:UIControlStateNormal] forState:UIControlStateNormal];
    [self.loginButton setBackgroundImage:[theme colorButtonBackgroundForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
    
    
    
    self.userTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 260, 50)];
    [self.userTextField setPlaceholder:@"Username"];
    [self.userTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    
    
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 260, 50)];
    [self.passwordTextField setPlaceholder:@"Password"];
    [self.passwordTextField setSecureTextEntry:YES];
    [self.passwordTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    self.title = @"Entrar";
    if([[PFUser currentUser] isAuthenticated]){
        [self appDelegate].isLoggedIn = YES;
        [self performSegueWithIdentifier:@"list" sender:self];
        
        

        
    }
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.userTextField = nil;
    self.passwordTextField = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell* cell = nil;
    
    if(indexPath.row == 0){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UsernameCell"];
        cell.selectedBackgroundView = nil;

        [cell addSubview:self.userTextField];
        
    }else {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PasswordCell"];
        cell.selectedBackgroundView = nil;
        [cell addSubview:self.passwordTextField];
    }
    
    return cell;
}


#pragma mark IB Actions

//Show the hidden register view
-(IBAction)signUpPressed:(id)sender
{
    [self performSegueWithIdentifier:@"signup" sender:self];
}

//Login button pressed
-(IBAction)logInPressed:(id)sender
{

    [self appDelegate].isLoggedIn = YES;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";
    [PFUser logInWithUsernameInBackground:self.userTextField.text password:self.passwordTextField.text
                                    block:^(PFUser *user, NSError *error) {
                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                        if (user) {
                                            [self appDelegate].isLoggedIn = YES;
                                            [self performSegueWithIdentifier:@"list" sender:self];
                                        } else {
                                            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error."
                                                                                             message:@"Datos No Válidos."
                                                                                            delegate:self
                                                                                   cancelButtonTitle:@"Ok"
                                                                                   otherButtonTitles:nil];
                                            
                                            [alert show];
                                        }
    }];
}

@end
