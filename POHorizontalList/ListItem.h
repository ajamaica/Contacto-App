//
//  ListItem.h
//  POHorizontalList
//
//  Created by Polat Olu on 15/02/2013.
//  Copyright (c) 2013 Polat Olu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ListItem : UIView {
    CGRect textRect;
    CGRect imageRect;
}

@property (nonatomic, retain) NSObject *objectTag;

@property (nonatomic, retain) NSString *imageTitle;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) PFObject *tienda;

- (id)initWithFrame:(CGRect)frame urlimage:(NSURL *)url text:(NSString *)imageTitle withobject:(PFObject *)tienda;
@end
