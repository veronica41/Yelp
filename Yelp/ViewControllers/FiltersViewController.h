//
//  FiltersViewController.h
//  Yelp
//
//  Created by Veronica Zheng on 6/17/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterOption.h"

@protocol FiltersViewControllerDelegate <NSObject>



@end

@interface FiltersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<FiltersViewControllerDelegate> delegate;
@property (nonatomic, strong) FilterOption * filterOption;

@end
