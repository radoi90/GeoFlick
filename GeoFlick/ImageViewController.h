//
//  ImageViewController.h
//  GeoFlick
//
//  Created by Emil Culic on 29/01/14.
//  Copyright (c) 2014 Emil Culic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController

// Model for this MVC ... URL of an image to display
@property (nonatomic, strong) NSURL *imageURL;

@end
