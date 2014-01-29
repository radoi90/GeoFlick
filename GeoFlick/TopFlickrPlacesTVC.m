//
//  TopFlickrPlacesTVC.m
//  GeoFlick
//
//  Created by Emil Culic on 28/01/14.
//  Copyright (c) 2014 Emil Culic. All rights reserved.
//

#import "TopFlickrPlacesTVC.h"
#import "FlickrFetcher.h"

@interface TopFlickrPlacesTVC ()

@end

@implementation TopFlickrPlacesTVC

// an argument can be made that this should be done in viewWillAppear:
//   (that way, the expensive operation of fetching will only happen
//    if our View is FOR SURE going to appear on screen).
// however, we'd have to be sure it only happens the first time
//   that viewWillAppear: is called, not on subsequent appearances

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchPlaces];
}

// this method is called in viewDidLoad,
//   but also when the user "pulls down" on the table view
//   (because this is the action of self.tableView.refreshControl)

- (IBAction)fetchPlaces
{
    [self.refreshControl beginRefreshing]; // start the spinner
    [self.tableView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height)];
    
    NSURL *url = [FlickrFetcher URLforTopPlaces];
    // create a (non-main) queue to do fetch on
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr fetcher", NULL);
    // put a block to do the fetch onto that queue
    dispatch_async(fetchQ, ^{
        // fetch the JSON data from Flickr
        NSData *jsonResults = [NSData dataWithContentsOfURL:url];
        // convert it to a Property List (NSArray and NSDictionary)
        NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                            options:0
                                                                              error:NULL];
        
        // get the NSArray of places NSDictionarys out of the results
        NSArray *places = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PLACES];
        // update the Model (and thus our UI), but do so back on the main queue
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing]; // stop the spinner
            self.places = places;
        });
    });
}

@end
