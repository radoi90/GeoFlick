//
//  FlickrPlacesTVC.m
//  GeoFlick
//
//  Created by Emil Culic on 29/01/14.
//  Copyright (c) 2014 Emil Culic. All rights reserved.
//

#import "FlickrPlacesTVC.h"
#import "FlickrFetcher.h"
#import "FlickrHelper.h"
#import "LocationFlickrPhotosTVC.h"

@interface FlickrPlacesTVC ()
@property (strong, nonatomic) NSArray *countries; // of String, country names
@property (strong, nonatomic) NSDictionary *placesByCountry;
@end

@implementation FlickrPlacesTVC

// whenever our Model is set, must update our View

- (void)setPlaces:(NSArray *)places
{
    _places = [FlickrHelper sortPlaces:places];
    
    self.placesByCountry = [FlickrHelper placesByCountry:_places];
    self.countries = [[self.placesByCountry allKeys]
                      sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                          return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
                      }];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

// the methods in this protocol are what provides the View its data
// (remember that Views are not allowed to own their data)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.countries count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section (we only have one)
    return [self.placesByCountry[self.countries[section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.countries[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // we must be sure to use the same identifier here as in the storyboard!
    static NSString *CellIdentifier = @"Flickr Place Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    // get the photo out of our Model
    NSDictionary *place = self.placesByCountry[self.countries[indexPath.section]][indexPath.row];
    
    // update UILabels in the UITableViewCell
    // valueForKeyPath: supports "dot notation" to look inside dictionaries at other dictionaries
    cell.textLabel.text = [FlickrHelper nameForPlace:place];
    cell.detailTextLabel.text = [FlickrHelper detailsForPlace:place];
    
    return cell;
}

#pragma mark - Navigation

// prepares the given LocationFlickrPhotosTVC to show photos at the given place
// used either when segueing to an LocationFlickrPhotosTVC

- (void)prepareLocationFlickrPhotosTVC:(LocationFlickrPhotosTVC *)lfptvc
                        toDisplayPlace:(NSDictionary *)place
{
    lfptvc.place = place;
    lfptvc.title = [FlickrHelper nameForPlace:place];
}

// In a story board-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        // find out which row in which section we're seguing from
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            // found it ... are we doing the Display Location segue?
            if ([segue.identifier isEqualToString:@"Display Location"]) {
                // yes ... is the destination an ImageViewController?
                if ([segue.destinationViewController isKindOfClass:[LocationFlickrPhotosTVC class]]) {
                    // yes ... then we know how to prepare for that segue!
                    [self prepareLocationFlickrPhotosTVC:segue.destinationViewController
                                          toDisplayPlace:self.placesByCountry[self.countries[indexPath.section]][indexPath.row]];
                }
            }
        }
    }
}

@end
