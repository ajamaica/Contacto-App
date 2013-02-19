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
    
	// Do any additional setup after loading the view.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation addUniqueObject:[NSString stringWithFormat:@"chat_%@",[[PFUser currentUser]objectId]] forKey:@"channels"];
    [currentInstallation saveInBackground];
    NSString *central = @"centerViewController";
   
    if(centralcontroler){
        central = centralcontroler;
    }
    
    [self setLeftPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"leftViewController"]];
    [self setCenterPanel:[self.storyboard instantiateViewControllerWithIdentifier:central]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
