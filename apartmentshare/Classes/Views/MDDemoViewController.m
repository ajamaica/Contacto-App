//
//  MDDemoViewController.m
//  Messages Demo
//
//  Created by Sam Soffes on 11/7/10.
//  Copyright 2010 Sam Soffes. All rights reserved.
//

#import "MDDemoViewController.h"
#import "SSMessageTableViewCell.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MBProgressHUD.h"

#define  MAX_ENTRIES_LOADED 25

@implementation MDDemoViewController{
    NSTimer *timer;
    UIActivityIndicatorView *actIndicator;
    int antes;
    BOOL primera;
}



#pragma mark UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    primera = FALSE;
    antes = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadchat:)
                                                 name:@"reloadchat"
                                               object:nil];

    
    scroll = FALSE;
    self.chatData  = [[NSMutableArray alloc] init];
    [self loadLocalChat];
    [self.sendButton addTarget:self action:@selector(sendsms:) forControlEvents:UIControlEventTouchUpInside];
    [self.sendButton setTitle:@"" forState:UIControlStateDisabled];
	
    actIndicator= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    actIndicator.tag = 123456;
    [actIndicator startAnimating];
    actIndicator.frame = CGRectMake(18, 3, 20, 20);
    }

-(void)loadView{
    [super loadView];
    
}

-(void)reloadchat:(NSNotification *) notification{
    [self loadLocalChat];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.chat = @"";
    //[timer invalidate];
    //timer = nil;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.chat = [self.chat objectId];
    
    //timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(loadLocalChatNoScroll) userInfo:nil repeats:YES];
}

-(void) playSound {
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"alert" ofType:@"wav"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
    AudioServicesPlaySystemSound (soundID);
    //[soundPath release];
}

-(void)sendsms:(id)sender{
    if([[self getText] length] <= 0){
        return;
    }
    
    [self.sendButton addSubview:actIndicator];
    

    [self.sendButton setEnabled:NO];
    
    
    
    PFObject *newMessage = [PFObject objectWithClassName:@"Mensajes"];
    [newMessage setObject:[self getText] forKey:@"mensaje"];
    [newMessage setObject:[PFUser currentUser] forKey:@"sender"];
    [newMessage setObject:self.chat forKey:@"chat"];
    [newMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self.sendButton setEnabled:YES];
        [actIndicator setHidden:YES];
        [actIndicator removeFromSuperview];
        if(!error){
                        
            NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [newMessage objectForKey:@"mensaje"], @"alert",
                                  [self.chat  objectId], @"p",
                                  @"alert.wav",@"sound",
                                  nil];
            
            [self.chat setObject:[newMessage objectForKey:@"mensaje"] forKey:@"last_ms"];
            
            if([[[self.chat objectForKey:@"seller"] objectId] isEqualToString:[[PFUser currentUser] objectId]]){
                
                PFPush *push = [[PFPush alloc] init];
                [push setChannel:[NSString stringWithFormat:@"chat_%@",[[self.chat objectForKey:@"buyer"] objectId]]];
                [push setData:data];
                [push sendPushInBackground];
                [self loadLocalChat];
                
                
                [self.chat setObject:[self.chat objectForKey:@"seller"] forKey:@"last_usr"];
                
            }else{
                PFPush *push = [[PFPush alloc] init];
                [push setChannel:[NSString stringWithFormat:@"chat_%@",[[self.chat objectForKey:@"seller"] objectId]]];

                [push setData:data];
                [push sendPushInBackground];
                
                [self.chat setObject:[self.chat objectForKey:@"buyer"] forKey:@"last_usr"];

                [self loadLocalChat];
                
            }
            
            [self.chat saveInBackground];
            
            
        }
    }];
    [self clear];
    
}

#pragma mark - Parse

- (void)loadLocalChat
{
    antes = [self.chatData count];
    
    if (!primera) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"Mensajes"];
    [query whereKey:@"chat" equalTo:self.chat];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
        query.cachePolicy = kPFCachePolicyNetworkOnly;
        [query orderByAscending:@"createdAt"];
        NSLog(@"Trying to retrieve from cache");
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                
                
                if((primera) && (antes != [self.chatData count])){
                    [self playSound];
                }
                
                primera = TRUE;
                // The find succeeded.

                [self.chatData removeAllObjects];
                [self.chatData addObjectsFromArray:objects];
                [self.tableView reloadData];
                if([self.chatData count]>0){
                    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([self.tableView numberOfRowsInSection:0] - 1) inSection:0];
                    [self.tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                
                }
                antes = [self.chatData count];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
               
                
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
