//
//  ADVLoginViewController.h
//  apartmentshare
//
//  Created by Tope Abayomi on 22/01/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMClient;

@interface ADVLoginViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) IBOutlet UITextField *userTextField;

@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;

@property (nonatomic, strong) IBOutlet UITableView *loginTableView;

@property (nonatomic, weak) IBOutlet UIButton *loginButton;

@property (nonatomic, weak) IBOutlet UIButton *signupButton;

@property (strong, nonatomic) SMClient *client;

-(IBAction)signUpPressed:(id)sender;
-(IBAction)logInPressed:(id)sender;

@end
