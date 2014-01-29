//
//  FlickerHelper.m
//  GeoFlick
//
//  Created by Emil Culic on 29/01/14.
//  Copyright (c) 2014 Emil Culic. All rights reserved.
//

#import "FlickrHelper.h"
#import "FlickrFetcher.h"

@implementation FlickrHelper

+ (NSArray *) sortPlaces:(NSArray *)places
{
    return [places sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *name1 = [obj1 valueForKeyPath:FLICKR_PLACE_NAME];
        NSString *name2 = [obj2 valueForKeyPath:FLICKR_PLACE_NAME];
        
        return [name1 localizedCompare:name2];
    }];
}

+ (NSDictionary *) placesByCountry:(NSArray *)places
{
    NSMutableDictionary *placesByCountry = [[NSMutableDictionary alloc] init];

    for (NSDictionary *place in places) {
        //extract country name from location description
        NSString *countryName = [self countryNameForPlace:place];
        
        //insert place in the corresponding array, create it if necessary
        if (![placesByCountry valueForKey:countryName]) {
            [placesByCountry setValue:[[NSMutableArray alloc]init]
                               forKey:countryName];
        }
        
        [[placesByCountry valueForKey:countryName] addObject:place];
    }
    
    return placesByCountry;
}

+ (NSString *) countryNameForPlace:(NSDictionary *)place
{
    return [[[place valueForKey:FLICKR_PLACE_NAME]
             componentsSeparatedByString:@", " ] lastObject];
}

+ (NSString *) nameForPlace:(NSDictionary *)place
{
    return [[[place valueForKey:FLICKR_PLACE_NAME]
             componentsSeparatedByString:@", " ] firstObject];
}

+ (NSString *) detailsForPlace:(NSDictionary *)place
{
    NSArray *locationDetails = [[place valueForKey:FLICKR_PLACE_NAME]
                                componentsSeparatedByString:@", "];
    
    NSRange range;
    range.location = 1;
    range.length = [locationDetails count] - 2;
    
    return [[locationDetails subarrayWithRange:range] componentsJoinedByString:@", "];
}

@end
