//
//  Apartment.h
//  apartmentshare
//
//  Created by Tope Abayomi on 22/02/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ApartmentSchema : NSObject

@property (nonatomic, strong) NSString * location;
@property (nonatomic, assign) float price;
@property (nonatomic, assign) int roomCount;
@property (nonatomic, strong) NSString * apartmentType;
@property (nonatomic, strong) NSString * photo;

@end
