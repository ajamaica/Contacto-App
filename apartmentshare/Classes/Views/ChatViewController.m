//
//  ChatViewController.m
//  Contacto
//
//  Created by Arturo Jamaica Garcia on 16/02/13.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "ChatViewController.h"
#import "MDDemoViewController.h"
#import "MensajesCell.h"
#import "UIImageView+WebCache.h"
#import "KGNoise.h"

@interface ChatViewController ()

@end

@implementation ChatViewController
- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.className = @"Chat";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"text";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // The className to query on
        self.className = @"Chat";
        
        // The key of the PFObject to display in the label of the default cell style
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
 

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    KGNoiseRadialGradientView *noiseView = [[KGNoiseRadialGradientView alloc] initWithFrame:self.view.frame];
    noiseView.backgroundColor = [UIColor colorWithRed:0.814 green:0.798 blue:0.747 alpha:1.000];
    noiseView.alternateBackgroundColor = [UIColor colorWithRed:1.000 green:0.986 blue:0.945 alpha:1.000];
    noiseView.noiseOpacity = 0.3;
    [self.tableView setBackgroundView:noiseView];
    self.title = @"Mensajes";
    
    [self loadObjects];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
  
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - PFQueryTableViewController

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}




 // Override to customize what kind of query to perform on the class. The default is to query for
 // all objects ordered by createdAt descending.
 - (PFQuery *)queryForTable {
     PFQuery *query1 = [PFQuery queryWithClassName:self.className];
     [query1 whereKey:@"seller" equalTo:[PFUser currentUser]];
     
     
     PFQuery *query2 = [PFQuery queryWithClassName:self.className];
     [query2 whereKey:@"buyer" equalTo:[PFUser currentUser]];
     

     PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects: query1, query2, nil]];
                       
     // If Pull To Refresh is enabled, query against the network by default.
     if (self.pullToRefreshEnabled) {
         query.cachePolicy = kPFCachePolicyNetworkOnly;
     }
 
     // If no objects are loaded in memory, we look to the cache first to fill the table
     // and then subsequently do a query against the network.
     if (self.objects.count == 0) {
         query.cachePolicy = kPFCachePolicyNetworkOnly;
     }
 
     [query orderByDescending:@"updatedAt"];
     
     [query includeKey:@"anuncio"];
     [query includeKey:@"seller"];
     [query includeKey:@"buyer"];
     
     return query;
 }


-(void)objectsDidLoad:(NSError *)error{
    [super objectsDidLoad:error];
    
}

 // Override to customize the look of a cell representing an object. The default is to display
 // a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
 // and the imageView being the imageKey in the object.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
     
     
     
     static NSString *CellIdentifier = @"MensajeCell";
 
     MensajesCell *cell = (MensajesCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil) {
         cell = [[MensajesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
     }
     [[object objectForKey:@"anuncio"] fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
         cell.titulo.text = [object objectForKey:@"title"];
     }];

     if([[[PFUser currentUser] objectId] isEqualToString:[[object objectForKey:@"last_usr"] objectId]]){
         
         cell.description.text = [NSString stringWithFormat:@"➡ %@",[object objectForKey:@"last_ms"]];
         
     }else{
         cell.description.text = [NSString stringWithFormat:@"⬅ %@",[object objectForKey:@"last_ms"]];
     }
     
          
     PFFile *f = [[object objectForKey:@"anuncio"] objectForKey:@"imagen"];
     [cell.imagen setImageWithURL:[NSURL URLWithString: f.url]];
     
     return cell;
 }


 

/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
 return [self.objects objectAtIndex:indexPath.row];
 }
 */

/*
 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"NextPage";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.text = @"Load more...";
 
 return cell;
 }
 */

#pragma mark - UITableViewDataSource


 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
     return YES;
 }
 


 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
     if (editingStyle == UITableViewCellEditingStyleDelete) {
         PFObject *ob = [self.objects objectAtIndex:indexPath.row];
         [ob deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
             [self loadObjects];
         }];
     } else if (editingStyle == UITableViewCellEditingStyleInsert) {
         // Create a new instance of the appropriate class, and save it to Parse
     }
 }
 

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    MDDemoViewController *chatviewcontroller = [[MDDemoViewController alloc] init];
    [chatviewcontroller setChat:[self.objects objectAtIndex:indexPath.row]];
    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    
    if([[[PFUser currentUser] objectId] isEqualToString:[[object objectForKey:@"seller"] objectId]]){
        
        chatviewcontroller.title = [NSString stringWithFormat:@"%@",[[object objectForKey:@"buyer"] objectForKey:@"username"]];
        
    }else{
        chatviewcontroller.title = [NSString stringWithFormat:@"%@",[[object objectForKey:@"seller"] objectForKey:@"username"]];
    }
    
    [self.navigationController pushViewController:chatviewcontroller animated:YES];
}
@end
