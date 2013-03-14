//
//  ListItem.m
//  POHorizontalList
//
//  Created by Polat Olu on 15/02/2013.
//  Copyright (c) 2013 Polat Olu. All rights reserved.
//

#import "ListItem.h"
#import "UIImageView+WebCache.h"
@implementation ListItem

- (id)initWithFrame:(CGRect)frame urlimage:(NSURL *)url text:(NSString *)imageTitle withobject:(PFObject *)tienda
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        
        [self setUserInteractionEnabled:YES];
        
        self.imageTitle = imageTitle;
        self.tienda = tienda;
        UIImageView *imageView = [[UIImageView alloc] init];
        
        if(url){
            [imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"7_64x64.png"]];
        }
        CALayer *roundCorner = [imageView layer];
        [roundCorner setMasksToBounds:YES];
        [roundCorner setCornerRadius:8.0];
        [roundCorner setBorderColor:[UIColor clearColor].CGColor];
        [roundCorner setBorderWidth:1.0];
        
        UILabel *title = [[UILabel alloc] init];
        [title setBackgroundColor:[UIColor clearColor]];
        [title setFont:[UIFont boldSystemFontOfSize:12.0]];
        [title setOpaque: NO];
        [title setText:imageTitle];
        
        imageRect = CGRectMake(0.0, 0.0, 72.0, 72.0);
        textRect = CGRectMake(0.0, imageRect.origin.y + imageRect.size.height + 10.0, 80.0, 20.0);
        
        [title setFrame:textRect];
        [imageView setFrame:imageRect];
        
        [self addSubview:title];
        [self addSubview:imageView];
    }
    
    return self;
}

@end
