//
//  SidebarViewController.m
//  Contacto
//
//  Created by Arturo Jamaica Garcia on 15/02/13.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "SidebarViewController.h"
#import "SidebarCell.h"
#import "UIViewController+JASidePanel.h"
#import "SSMessagesViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface SidebarViewController ()

@end

@implementation SidebarViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    KGNoiseRadialGradientView *noiseView = [[KGNoiseRadialGradientView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    noiseView.backgroundColor = [UIColor colorWithRed:0.083 green:0.083 blue:0.083 alpha:1.000];
    noiseView.alternateBackgroundColor = [UIColor colorWithRed:0.184 green:0.184 blue:0.184 alpha:1.000];
    noiseView.noiseOpacity = 0.1;
    [self.parentViewController.view insertSubview:noiseView atIndex:0];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuCell";
    SidebarCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            cell.title.text = @"Preferencias";
            cell.uiimage.image = [UIImage imageNamed:@"32.png"];
            [cell.notification setHidden:YES];
            break;
        case 1:
            cell.title.text = @"Listado";
            cell.uiimage.image = [UIImage imageNamed:@"32.png"];
            [cell.notification setHidden:YES];
            break;
        case 2:
            cell.title.text = @"Mis Anuncios";
            cell.uiimage.image = [UIImage imageNamed:@"36.png"];
            [cell.notification setHidden:YES];
            break;
        case 3:
            cell.title.text = @"Mis Mensajes";
            cell.uiimage.image = [UIImage imageNamed:@"31.png"];
            [cell.notification.layer setCornerRadius:10.0f];
            [cell.notification.layer setMasksToBounds:YES];
            break;
        case 4:
            cell.title.text = @"Salir";
            cell.uiimage.image = [UIImage imageNamed:@"4.png"];
            [cell.notification setHidden:YES];
            break;
        case 5:
            cell.title.text = @"Mis Datos";
            cell.uiimage.image = [UIImage imageNamed:@"32.png"];
            [cell.notification setHidden:YES];
            break;

        default:
            break;
    }
    
    
    
    return cell;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appDelegate;
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];

    switch (indexPath.row) {
        case 0:
            [SZUserUtils showUserSettingsInViewController:self.sidePanelController.centerPanel completion:^{
                
                SZUserSettings *settings = [SZUserUtils currentUserSettings];
                
                // Update the server
                [SZUserUtils saveUserSettings:settings success:^(SZUserSettings *settings, id<SocializeFullUser> updatedUser) {
                    PFUser *pf = [PFUser currentUser];
                    pf.username  = settings.firstName;
                    [pf saveInBackground];
                    NSLog(@"Saved user %d", [updatedUser objectID]);
                } failure:^(NSError *error) {
                    NSLog(@"Broke: %@", [error localizedDescription]);
                }];
                
            }];
            
            break;
        case 1:
    
            self.sidePanelController.centerPanel =[self.storyboard instantiateViewControllerWithIdentifier:@"centerViewController"];
            break;
        case 2:
            self.sidePanelController.centerPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"misanuncios"];
            break;
        case 3:
            self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"chat"]];
            break;
        case 4:
            [PFUser logOut];
            currentInstallation.channels = [NSArray array];
            [currentInstallation saveEventually];
            appDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
            [appDelegate logout];
            break;
        default:
            break;
    }

    
    

    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
