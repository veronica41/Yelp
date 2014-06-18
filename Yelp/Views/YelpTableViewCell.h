//
//  YelpTableViewCell.h
//  Yelp
//
//  Created by Veronica Zheng on 6/17/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Business.h"

@interface YelpTableViewCell : UITableViewCell

@property (nonatomic, strong) Business * business;

- (void)setBusiness:(Business *)business;

@end
