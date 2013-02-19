//
//  ADVRegisterViewController.m
//  apartmentshare
//
//  Created by Tope Abayomi on 22/02/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "ADVRegisterViewController.h"
#import "AppDelegate.h"
#import "ADVTheme.h"
#import "MBProgressHUD.h"

@interface ADVRegisterViewController ()

@end


@implementation ADVRegisterViewController

@synthesize userRegisterTextField = _userRegisterTextField, passwordRegisterTextField = _passwordRegisterTextField;
@synthesize managedObjectContext = _managedObjectContext;

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    id <ADVTheme> theme = [ADVThemeManager sharedTheme];
    
    
    
    self.loginTableView = [[UITableView alloc] initWithFrame:CGRectMake(16, 0, 294, 160) style:UITableViewStyleGrouped];
    
    [self.loginTableView setScrollEnabled:NO];
    [self.loginTableView setBackgroundView:nil];
    [self.view addSubview:self.loginTableView];
    
    [self.loginTableView setDataSource:self];
    [self.loginTableView setDelegate:self];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[theme viewBackground]]];
    
    
    [self.signupButton setBackgroundImage:[theme buttonBackgroundForState:UIControlStateNormal] forState:UIControlStateNormal];
    [self.signupButton setBackgroundImage:[theme buttonBackgroundForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
    
    
    
    self.userRegisterTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 260, 50)];
    [self.userRegisterTextField setPlaceholder:@"Username"];
    [self.userRegisterTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    
    
    self.passwordRegisterTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 260, 50)];
    [self.passwordRegisterTextField setPlaceholder:@"Password"];
    [self.passwordRegisterTextField setSecureTextEntry:YES];
    [self.passwordRegisterTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    
    self.emailRegisterTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 260, 50)];
    [self.emailRegisterTextField setPlaceholder:@"Email"];
    [self.emailRegisterTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.userRegisterTextField = nil;
    self.passwordRegisterTextField = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = nil;
    
    if(indexPath.row == 0){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UsernameCell"];
        cell.selectedBackgroundView = nil;
        [cell addSubview:self.userRegisterTextField];
        
    }else if(indexPath.row == 1){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PasswordCell"];
        cell.selectedBackgroundView = nil;
        [cell addSubview:self.passwordRegisterTextField];
    }else if(indexPath.row == 2){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PasswordCell"];
        cell.selectedBackgroundView = nil;
        [cell addSubview:self.emailRegisterTextField];
    }
    
    return cell;
}

#pragma mark IB Actions

////Sign Up Button pressed
-(IBAction)signUpUserPressed:(id)sender
{
    
    PFUser *user = [PFUser user];
    user.username = self.userRegisterTextField.text;
    user.password = self.passwordRegisterTextField.text;
    user.email = self.emailRegisterTextField.text;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            [self performSegueWithIdentifier:@"list" sender:self];
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error."
                                                             message:errorString
                                                            delegate:self
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles:nil];
            
            [alert show];
        }
    }];
    
    
}

@end
