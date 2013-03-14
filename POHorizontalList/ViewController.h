//
//  ViewController.h
//  POHorizontalList
//
//  Created by Polat Olu on 17/02/2013.
//  Copyright (c) 2013 Polat Olu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POHorizontalList.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, POHorizontalListDelegate> {
    NSMutableArray *itemArray;
    
    NSMutableArray *destacados;
    NSMutableArray *cercanos;
    NSMutableArray *mistiendas;
}
- (IBAction)nuevatienda:(id)sender;

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
