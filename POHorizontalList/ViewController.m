//
//  ViewController.m
//  POHorizontalList
//
//  Created by Polat Olu on 15/02/2013.
//  Copyright (c) 2013 Polat Olu. All rights reserved.
//

#import "ViewController.h"
#import "TiendaViewController.h"

@interface ViewController (){
    BOOL isloading1;
    BOOL isloading2;
    BOOL isloading3;
    UIRefreshControl *refreshControl;

    PFObject *tienda;
}

@end

@implementation ViewController

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        isloading1 =YES;
        isloading2 =YES;
        isloading3 =YES;

        
        

    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"reloadpurchase"
                                               object:nil];
}

-(void)handleRefresh:(id)sender{
    PFQuery *queredestacados = [PFQuery queryWithClassName:@"Tiendas"];
    
    [queredestacados whereKey:@"destacada" equalTo:[NSNumber numberWithBool:YES]];
    

    
    [queredestacados findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            
            destacados = [[NSMutableArray alloc] initWithCapacity:objects.count];
            
            for (PFObject *t in objects) {
                PFFile *pf = [t objectForKey:@"logo"];
                NSString *s =@"";
                if(pf){
                    s = pf.url;
                }
                [destacados addObject:[[ListItem alloc] initWithFrame:CGRectZero urlimage:[NSURL URLWithString:s] text:[t objectForKey:@"nombre"] withobject:t]];
            }
        }
        isloading1 = NO;
        [self.tableView reloadData];
        
    }];
    
    PFQuery *querycercanos = [PFQuery queryWithClassName:@"Tiendas"];
    
    if([[PFUser currentUser] objectForKey:@"location"]){
        [querycercanos whereKey:@"location" nearGeoPoint:[[PFUser currentUser] objectForKey:@"location"] withinKilometers:30.0f];
    }
    
    [querycercanos findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            cercanos = [[NSMutableArray alloc] initWithCapacity:objects.count];
            
            for (PFObject *t in objects) {
                PFFile *pf = [t objectForKey:@"logo"];
                NSString *s =@"";
                if(pf){
                    s = pf.url;
                }
                [cercanos addObject:[[ListItem alloc] initWithFrame:CGRectZero urlimage:[NSURL URLWithString:s] text:[t objectForKey:@"nombre"] withobject:t]];            }
        }
        isloading2 =NO;
        [self.tableView reloadData];
        
    }];
    
    
    PFQuery *querymistiendas = [PFQuery queryWithClassName:@"Tiendas"];
    
    [querymistiendas whereKey:@"user" equalTo:[PFUser currentUser]];
    
    [querymistiendas findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            mistiendas = [[NSMutableArray alloc] initWithCapacity:objects.count];
            for (PFObject *t in objects) {
                PFFile *pf = [t objectForKey:@"logo"];
                NSString *s =@"";
                if(pf){
                    s = pf.url;
                }
                
                [mistiendas addObject:[[ListItem alloc] initWithFrame:CGRectZero urlimage:[NSURL URLWithString:s] text:[t objectForKey:@"nombre"] withobject:t]];            }
        }
        isloading3 =NO;
        [self.tableView reloadData];
        [refreshControl endRefreshing];
    }];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Tiendas";
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Tira para recargar."];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];

    [self.tableView addSubview:refreshControl];
    [self handleRefresh:self];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)numberOfSectionsInTableView:(UITableView *)tableView {
    if(isloading1 && isloading2 && isloading3){
        return 0;
    }
    return 1;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(isloading1 && isloading2 && isloading3){
        return 0;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 175.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSString *title = @"";
    POHorizontalList *list;
    
    if ([indexPath row] == 0) {
        title = @"Tiendas Destacadas";
        
        list = [[POHorizontalList alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 175.0) title:title items:destacados];
    }
    else if ([indexPath row] == 1) {
        title = @"Tiendas Cercanas";
        
        list = [[POHorizontalList alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 175.0) title:title items:cercanos];
    }
    else if ([indexPath row] == 2) {
        title = @"Mis Tiendas";
        
        list = [[POHorizontalList alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 175.0) title:title items:mistiendas];
    }
    
    [list setDelegate:self];
    [cell.contentView addSubview:list];
    
    return cell;
}

#pragma mark  POHorizontalListDelegate

- (void) didSelectItem:(ListItem *)item {

    tienda = item.tienda;
    [self performSegueWithIdentifier:@"adsstore" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"adsstore"]){

        TiendaViewController *vc = [segue destinationViewController];
        [vc setTitle:[tienda objectForKey:@"nombre"]];
        
        [vc setTienda: tienda];

    }
}

- (IBAction)nuevatienda:(id)sender {
    
    [PFPurchase buyProduct:@"com.brounie.contacto.tienda" block:^(NSError *error) {
        if (!error) {

        }
    }];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end