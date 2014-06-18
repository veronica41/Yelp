//
//  RadiusCell.h
//  Yelp
//
//  Created by Veronica Zheng on 6/18/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadiusCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *radiusLabel;

@end
