//
//  LocationFlickrPhotosTVC.m
//  GeoFlick
//
//  Created by Emil Culic on 28/01/14.
//  Copyright (c) 2014 Emil Culic. All rights reserved.
//

#import "LocationFlickrPhotosTVC.h"
#import "FlickrFetcher.h"

@implementation LocationFlickrPhotosTVC

// an argument can be made that this should be done in viewWillAppear:
//   (that way, the expensive operation of fetching will only happen
//    if our View is FOR SURE going to appear on screen).
// however, we'd have to be sure it only happens the first time
//   that viewWillAppear: is called, not on subsequent appearances

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchPhotos];
}

// this method is called in viewDidLoad,
//   but also when the user "pulls down" on the table view
//   (because this is the action of self.tableView.refreshControl)

- (IBAction)fetchPhotos
{
    [self.refreshControl beginRefreshing]; // start the spinner
    [self.tableView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height)];
    
    NSURL *url = [FlickrFetcher URLforPhotosInPlace:self.place[FLICKR_PLACE_ID] maxResults:50];
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
        // get the NSArray of photo NSDictionarys out of the results
        NSArray *photos = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];

        // update the Model (and thus our UI), but do so back on the main queue
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing]; // stop the spinner
            self.photos = photos;
        });
    });
}

@end
