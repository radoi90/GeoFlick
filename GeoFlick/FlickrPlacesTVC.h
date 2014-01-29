//
//  FlickrPlacesTVC.h
//  GeoFlick
//
//  Created by Emil Culic on 29/01/14.
//  Copyright (c) 2014 Emil Culic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrPlacesTVC : UITableViewController

// Model of this MVC (it can be publicly set)
@property (nonatomic, strong) NSArray *places; // of Flickr places NSDictionary

@end
