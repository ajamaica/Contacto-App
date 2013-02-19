//
//  MisAnunciosViewController.m
//  Contacto
//
//  Created by Arturo Jamaica Garcia on 16/02/13.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "MisAnunciosViewController.h"
#import "AppDelegate.h"

@interface MisAnunciosViewController ()

@end

@implementation MisAnunciosViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
} 

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	 self.navigationItem.rightBarButtonItem = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
