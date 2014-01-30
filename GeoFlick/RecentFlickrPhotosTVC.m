//
//  RecentFlickrPhotosTVC.m
//  GeoFlick
//
//  Created by Emil Culic on 28/01/14.
//  Copyright (c) 2014 Emil Culic. All rights reserved.
//

#import "RecentFlickrPhotosTVC.h"
#import "FlickrHelper.h"

@interface RecentFlickrPhotosTVC ()

@end

@implementation RecentFlickrPhotosTVC

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.photos = [FlickrHelper allRecentPhotos];
}

@end
