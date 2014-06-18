//
//  MainViewController.h
//  Yelp
//
//  Created by Veronica Zheng on 6/17/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "UIColor+Yelp.h"
#import "YelpClient.h"
#import "Business.h"
#import "YelpTableViewCell.h"
#import "FiltersViewController.h"

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate, FiltersViewControllerDelegate>

@end
