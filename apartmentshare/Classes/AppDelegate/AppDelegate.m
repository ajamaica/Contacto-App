//
//  AppDelegate.m
//  apartmentshare
//
//  Created by Tope on 25/01/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "AppDelegate.h"
#import "ADVTheme.h"
#import "MPNotificationView.h"
#import "MySidePanelControllerViewController.h"
#import "MDDemoViewController.h"
#import "JASidePanelController.h"

@implementation AppDelegate




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    [ADVThemeManager customizeAppAppearance];
    
    [Socialize storeConsumerKey:@"945ba670-6934-4192-a08e-ee1860af9096"];
    [Socialize storeConsumerSecret:@"807b3c94-a371-42e7-a111-a071fd5ca6dd"];
    [Socialize storeAnonymousAllowed:YES];
    
    
    [SZTwitterUtils setConsumerKey:@"1igIqTQDlkzcIWqS1dzIXQ" consumerSecret:@"08ocJnSFwwriWlUuPCvzlHXHkquCT7fsdckve4HM"];

    [SZFacebookUtils setAppId:@"504782069564646"];
    
    [Parse setApplicationId:@"9WcDOFquwPQxQDdYi3mrSkYyBPBbJ73ZPnu9X3p4"
                  clientKey:@"9EOYnPWrIeIDpmCoeW2ywBh7IalKcnreknpSA1la"];
  
   

    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];

    
    NSDictionary *notifPayload =
    [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    
    if([Socialize handleNotification:notifPayload]){
    
    }else{
        // Create empty photo object
        NSString *photoId = [notifPayload objectForKey:@"p"];
        
        if(photoId){
        PFObject *targetPhoto = [PFObject objectWithoutDataWithClassName:@"Chat"
                                                            objectId:photoId];
    
       
        
        // Fetch photo object
        [targetPhoto fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        // Show photo view controller
            if (!error && [PFUser currentUser]) {
                
                MySidePanelControllerViewController *ms = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"sidepanels"];
                
                UINavigationController *c = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"chatnav"];
                
                MDDemoViewController *chatviewcontroller = [[MDDemoViewController alloc] init];
                [chatviewcontroller setChat:targetPhoto];
                chatviewcontroller.title = @"Chat";
                
                [c pushViewController:chatviewcontroller animated:YES];
                [ms setCentralcontroler:c];
                
                
                              
                self.window.rootViewController =  ms;
                
            }
        }];
        }

    }
    
    [Socialize setEntityLoaderBlock:^(UINavigationController *navigationController, id<SocializeEntity>entity) {
        
        SampleEntityLoader *entityLoader = [[SampleEntityLoader alloc] initWithEntity:entity];
        
        if (navigationController == nil) {
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:entityLoader];
            [self.window.rootViewController presentModalViewController:navigationController animated:YES];
        } else {
            [navigationController pushViewController:entityLoader animated:YES];
        }
    }];

    
    if([PFUser currentUser]){
        
        self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"sidepanels"];
        
                
    }
    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [Socialize handleOpenURL:url];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    
    if ([Socialize handleNotification:userInfo]) {
        return;
    }
    
   [[NSNotificationCenter defaultCenter] postNotificationName: @"reloadchat" object:nil userInfo:userInfo];
    
    if([self.chat isEqualToString:[userInfo objectForKey:@"p"]]){
        return;
    }
    
    
    
    NSString *photoId = [userInfo objectForKey:@"p"];
    
    if(photoId){
        PFObject *targetPhoto = [PFObject objectWithoutDataWithClassName:@"Chat"
                                                                objectId:photoId];
        
        
        
        // Fetch photo object
        [targetPhoto fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            // Show photo view controller
            if (!error && [PFUser currentUser]) {
                
                
                [MPNotificationView notifyWithText:@"Nuevo mensaje en una venta" detail:[[userInfo objectForKey:@"aps"] objectForKey:@"alert" ] image:[UIImage imageNamed:@"57.png"] duration:2.0 andTouchBlock:^(MPNotificationView *notificationView) {
                    
                    if (!error && [PFUser currentUser]) {
                        
                        MySidePanelControllerViewController *ms = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"sidepanels"];
                        
                        UINavigationController *c = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"chatnav"];
                        
                        MDDemoViewController *chatviewcontroller = [[MDDemoViewController alloc] init];
                        [chatviewcontroller setChat:targetPhoto];
                        chatviewcontroller.title = @"Chat";
                        
                        [c pushViewController:chatviewcontroller animated:YES];
                        [ms setCentralcontroler:c];
                        
                        
                        
                        self.window.rootViewController =  ms;
                        
                    }

                   
                    
                    
                }];
                
                
                
                
            }
        }];
    }
    
    
    

}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current Installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

-(void)logout{
    
    self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"incio"];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
