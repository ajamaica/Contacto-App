//
//  MDDemoViewController.m
//  Messages Demo
//
//  Created by Sam Soffes on 11/7/10.
//  Copyright 2010 Sam Soffes. All rights reserved.
//

#import "MDDemoViewController.h"
#import "SSMessageTableViewCell.h"
#define  MAX_ENTRIES_LOADED 25
@implementation MDDemoViewController{
    NSTimer *timer;
}

NSString *lorem[] = {
	@"Hi",
	@"This is a work in progress",
	@"Ya I know",
	@"Fine then\nI see how it is",
	@"Do you? Do you really?",
	@"Yes"
};

#pragma mark UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    scroll = FALSE;
    self.chatData  = [[NSMutableArray alloc] init];
    [self loadLocalChat];
    [self.sendButton addTarget:self action:@selector(sendsms:) forControlEvents:UIControlEventTouchUpInside];
    
	
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [timer invalidate];
    timer = nil;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(loadLocalChatNoScroll) userInfo:nil repeats:YES];
}
-(void)sendsms:(id)sender{
    if([[self getText] length] <= 0){
        return;
    }
    PFObject *newMessage = [PFObject objectWithClassName:@"Mensajes"];
    [newMessage setObject:[self getText] forKey:@"mensaje"];
    [newMessage setObject:[PFUser currentUser] forKey:@"sender"];
    [newMessage setObject:self.chat forKey:@"chat"];
    [newMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error){
            
            PFPush *push = [[PFPush alloc] init];
            [push setChannel:[NSString stringWithFormat:@"chat_%@",[[self.chat objectForKey:@"seller"] objectId]]];
            [push setMessage:[newMessage objectForKey:@"mensaje"]];
            [push sendPushInBackground];
            
            [self loadLocalChat];
        }
    }];
    [self clear];
    
}

#pragma mark - Parse

- (void)loadLocalChat
{
    PFQuery *query = [PFQuery queryWithClassName:@"Mensajes"];
    [query whereKey:@"chat" equalTo:self.chat];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        [query orderByAscending:@"createdAt"];
        NSLog(@"Trying to retrieve from cache");
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                NSLog(@"Successfully retrieved %d chats from cache.", objects.count);
                [self.chatData removeAllObjects];
                [self.chatData addObjectsFromArray:objects];
                [self.tableView reloadData];
                if([self.chatData count]>0){
                    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([self.tableView numberOfRowsInSection:0] - 1) inSection:0];
                    [self.tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                
                }
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
        
    
    
}


- (void)loadLocalChatNoScroll
{
    PFQuery *query = [PFQuery queryWithClassName:@"Mensajes"];
    [query whereKey:@"chat" equalTo:self.chat];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query orderByAscending:@"createdAt"];
    NSLog(@"Trying to retrieve from cache");
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d chats from cache.", objects.count);
            [self.chatData removeAllObjects];
            [self.chatData addObjectsFromArray:objects];
            [self.tableView reloadData];
            
            
            
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
	}
	return YES;
}


#pragma mark SSMessagesViewController

- (SSMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *obj = [self.chatData objectAtIndex:indexPath.row];
	if ([[[obj objectForKey:@"sender"] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
		return SSMessageStyleRight;
	}
	return SSMessageStyleLeft;
}


- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *obj = [self.chatData objectAtIndex:indexPath.row];
	return [obj objectForKey:@"mensaje"];
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.chatData  count];
}


@end
