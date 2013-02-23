//
//  MySidePanelControllerViewController.m
//  Contacto
//
//  Created by Arturo Jamaica Garcia on 15/02/13.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "MySidePanelControllerViewController.h"

@interface MySidePanelControllerViewController ()

@end

@implementation MySidePanelControllerViewController
@synthesize centralcontroler;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void) awakeFromNib
{
    /*
    [self setLeftPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"leftViewController"]];
    [self setCenterPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"centerViewController"]];
     */
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Specify a new image and description for the current user
    SZUserSettings *settings = [SZUserUtils currentUserSettings];
    settings.firstName = [PFUser currentUser].username;
    
    // Update the server
    [SZUserUtils saveUserSettings:settings success:^(SZUserSettings *settings, id<SocializeFullUser> updatedUser) {
        PFUser *pf = [PFUser currentUser];
        [pf setUsername:settings.firstName];
        [pf saveEventually];
        NSLog(@"Saved user %d", [updatedUser objectID]);
    } failure:^(NSError *error) {
        NSLog(@"Broke: %@", [error localizedDescription]);
    }];

    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            PFUser *u = [PFUser currentUser];
            [u setObject:geoPoint forKey:@"location"];
            [u saveInBackground];
            [[NSNotificationCenter defaultCenter] postNotificationName: @"reload" object:nil userInfo:nil];
        }
    }];
    
	// Do any additional setup after loading the view.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation addUniqueObject:[NSString stringWithFormat:@"chat_%@",[[PFUser currentUser]objectId]] forKey:@"channels"];
    [currentInstallation saveInBackground];
   
    if(centralcontroler){
        [self setCenterPanel:centralcontroler];
    }else{
        [self setCenterPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"centerViewController"]];

    }
    
    [self setLeftPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"leftViewController"]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
