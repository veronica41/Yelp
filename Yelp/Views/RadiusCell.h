//
//  RadiusCell.h
//  Yelp
//
//  Created by Veronica Zheng on 6/18/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RADIUS_MIN 0
#define RADIUS_MAX 40000

@protocol RadiusCellDelegate <NSObject>

- (void)sliderValueChanged:(int)value;

@end

@interface RadiusCell : UITableViewCell

@property (nonatomic) NSInteger radius;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *radiusLabel;
@property (weak, nonatomic) id<RadiusCellDelegate> delegate;

- (IBAction)sliderValueChanged:(id)sender;

@end
