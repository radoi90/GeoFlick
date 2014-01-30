//
//  FlickerHelper.h
//  GeoFlick
//
//  Created by Emil Culic on 29/01/14.
//  Copyright (c) 2014 Emil Culic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrHelper : NSObject

+ (NSArray *) sortPlaces:(NSArray *)places;
+ (NSDictionary *) placesByCountry:(NSArray *)places;
+ (NSString *) countryNameForPlace:(NSDictionary *)place;
+ (NSString *) nameForPlace:(NSDictionary *)place;
+ (NSString *) detailsForPlace:(NSDictionary *)place;
+ (NSArray *) allRecentPhotos;
+ (void) addPhotoToRecents:(NSDictionary *)photo;

@end
