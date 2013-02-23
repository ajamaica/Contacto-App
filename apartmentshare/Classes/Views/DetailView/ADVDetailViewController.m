//
//  ADVDetailViewController.m
//  apartmentshare
//
//  Created by Tope on 30/01/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "ADVDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ADVTheme.h"
#import "UIImageView+WebCache.h"
#import "MDDemoViewController.h"
#import "MBProgressHUD.h"

@interface ADVDetailViewController ()

@end

@implementation ADVDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.actionBar == nil) {
        PFFile *file = [self.apartment objectForKey:@"imagen"];
        
        self.entity = [SZEntity entityWithKey:[self.apartment objectId] name:@"Anuncio"];

        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self.apartment objectForKey:@"title"], @"szsd_title",
                                [self.apartment objectForKey:@"details"], @"szsd_description",
                                file.url, @"szsd_thumb",
                                nil];
        
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
        NSAssert(error == nil, @"Error writing json: %@", [error localizedDescription]);
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        self.entity.meta = jsonString;
        
        
        self.actionBar = [SZActionBarUtils showActionBarWithViewController:self entity:self.entity options:nil];
        SZActionButton *btn = [SZActionButton viewsButton];
        [btn.actualButton removeFromSuperview];
        self.actionBar.itemsLeft = [NSArray arrayWithObjects:btn,nil];
        
        
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title =[self.apartment objectForKey:@"title"];
    
    CAGradientLayer *l = [CAGradientLayer layer];
    l.frame = self.shadowView.bounds;
    UIColor* startColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    UIColor* endColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    l.colors = [NSArray arrayWithObjects:(id)startColor.CGColor, (id)endColor.CGColor, nil];
    [self.shadowView.layer addSublayer:l];
    
    id <ADVTheme> theme = [ADVThemeManager sharedTheme];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[theme viewBackground]]];
    
    [self.contactButton setBackgroundImage:[theme colorButtonBackgroundForState:UIControlStateNormal] forState:UIControlStateNormal];
    [self.contactButton setBackgroundImage:[theme colorButtonBackgroundForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
    

    if([[[PFUser currentUser] objectId] isEqualToString:[[self.apartment objectForKey:@"user"] objectId]]){
        [self.contactButton setTitle:@"Tu vendes este producto" forState:UIControlStateNormal];
    }else{
        [self.contactButton addTarget:self action:@selector(contactar:) forControlEvents:UIControlEventTouchUpInside];

    }
    [[self.apartment objectForKey:@"user"] fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        self.user.text = [object objectForKey:@"username"];
    }];
    
    
    CGRect frame = self.moreDetailsTextView.frame;
    frame.size.height = self.moreDetailsTextView.contentSize.height;
    self.moreDetailsTextView.frame = frame;
    
    CGRect moreViewFrame =  self.moreDetailsView.frame;
    moreViewFrame.size.height = frame.size.height + 40;
    self.moreDetailsView.frame = moreViewFrame;
    
    int scrollViewHeight =  moreViewFrame.size.height + 299;
    self.scrollView.contentSize = CGSizeMake(320, scrollViewHeight);
    
    CAGradientLayer *topShadow = [CAGradientLayer layer];
    topShadow.frame = CGRectMake(0, -3, 320, 3);
    UIColor* startColor2 = [UIColor colorWithWhite:0.0 alpha:0.0];
    UIColor* endColor2 = [UIColor colorWithWhite:0.0 alpha:0.3];
    topShadow.colors = [NSArray arrayWithObjects:(id)startColor2.CGColor, (id)endColor2.CGColor, nil];
    [self.moreDetailsView.layer addSublayer:topShadow];
    
    CAGradientLayer *bottomShadow = [CAGradientLayer layer];
    bottomShadow.frame = CGRectMake(0, self.moreDetailsView.frame.origin.y + self.moreDetailsView.frame.size.height, 320, 3);
    bottomShadow.colors = [NSArray arrayWithObjects:(id)startColor2.CGColor, (id)endColor2.CGColor, nil];
    [self.moreDetailsView.layer addSublayer:bottomShadow];
        
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *priceString = [numberFormatter stringFromNumber:[self.apartment objectForKey:@"price"]];
    
    PFGeoPoint *pf = [[PFUser currentUser] objectForKey:@"location"];
    
    float d= [pf distanceInKilometersTo: [self.apartment objectForKey:@"location"]];
    NSString* roomCountText = [NSString stringWithFormat:@"%.02f Km", d];

    [self.moreDetailsTextView setText:[self.apartment objectForKey:@"details"]];
    
    [self.priceLabel setText:priceString];
    [self.roomsLabel setText:roomCountText];
    
    if([[[self.apartment objectForKey:@"category"] objectId] isEqualToString:@"re5rF1jMkb"]){
        [self.apartmentTypeLabel setText:@"Autos"];
    }
    
    if([[[self.apartment objectForKey:@"category"] objectId] isEqualToString:@"O30KnNmp2l"]){
        [self.apartmentTypeLabel setText:@"Bienes"];
    }
    
    if([[[self.apartment objectForKey:@"category"] objectId] isEqualToString:@"B5HNeL8Clg"]){
        [self.apartmentTypeLabel setText:@"Varios"];
    }
    
    
  
    PFFile *file = [self.apartment objectForKey:@"imagen"];
    
    [self.apartmentImageView setImageWithURL:[NSURL URLWithString:[file url]] placeholderImage:[UIImage imageNamed:@"apartment-1.jpg"]];
    
    self.mediaFocusManager = [[ASMediaFocusManager alloc] init];
    self.mediaFocusManager.delegate = self;
    [self.mediaFocusManager installOnView:self.apartmentImageView];
    
}

#pragma mark - ASMediaFocusDelegate
- (UIImage *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager imageForView:(UIView *)view
{
    return ((UIImageView *)view).image;
}

- (CGRect)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager finalFrameforView:(UIView *)view
{
    return self.parentViewController.view.bounds;
}

- (UIViewController *)parentViewControllerForMediaFocusManager:(ASMediaFocusManager *)mediaFocusManager
{
    return self.parentViewController;
}



-(void)contactar:(id)sender{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";
    
    PFQuery *query = [PFQuery queryWithClassName:@"Chat"];
    [query whereKey:@"buyer" equalTo:[PFUser currentUser]];
    [query whereKey:@"anuncio" equalTo:self.apartment];
    [query includeKey:@"buyer"];
    [query includeKey:@"seller"];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        PFObject *chat;
        if(!error){
            chat =object;
            [chat setObject:self.apartment forKey:@"anuncio"];
            [chat saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(!error){
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    MDDemoViewController *chatviewcontroller = [[MDDemoViewController alloc] init];
                    [chatviewcontroller setChat:chat];
                    chatviewcontroller.title = [[object objectForKey:@"seller"] username];
                    [self.navigationController pushViewController:chatviewcontroller animated:YES];
                }else{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }
            }];
        }else if(error.code == 101){
            chat =[PFObject objectWithClassName:@"Chat"];
            [chat setObject:[PFUser currentUser] forKey:@"buyer"];
            [chat setObject:[self.apartment objectForKey:@"user"] forKey:@"seller"];
            [chat setObject:self.apartment forKey:@"anuncio"];
            [chat saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(!error){
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    MDDemoViewController *chatviewcontroller = [[MDDemoViewController alloc] init];
                    [chatviewcontroller setChat:chat];
                    chatviewcontroller.title = [[object objectForKey:@"seller"] username];
                    [self.navigationController pushViewController:chatviewcontroller animated:YES];
                }else{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }
            }];
        }
        
        
        
    }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
