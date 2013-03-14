//
//  TiendaViewController.m
//  Contacto
//
//  Created by Arturo Jamaica Garcia on 01/03/13.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "TiendaViewController.h"
#import "MBProgressHUD.h"

@interface TiendaViewController ()

@end

@implementation TiendaViewController

@synthesize loading;
@synthesize refreshControl;
@synthesize objects;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Editar" style:UIBarButtonItemStylePlain target:self action:@selector(editar:)];
    
    self.logo.image = [UIImage imageNamed:@"sb"];
	// Do any additional setup after loading the view.
}


- (void)doquery{
    PFQuery *query = [PFQuery queryWithClassName:@"Anuncio"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
  
    
    [query whereKey:@"Vendido" equalTo:[NSNumber numberWithBool:NO]];
    
    [query whereKey:@"Eliminado" notEqualTo:[NSNumber numberWithBool:YES]];
    [query includeKey:@"user"];
    
    [query whereKey:@"tienda" equalTo:self.tienda];
    
    
    
    
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
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)editar:(id)sender{
    
}
@end
