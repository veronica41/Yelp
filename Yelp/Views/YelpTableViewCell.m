//
//  YelpTableViewCell.m
//  Yelp
//
//  Created by Veronica Zheng on 6/17/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpTableViewCell.h"
#import "YelpImageHelper.h"

@interface YelpTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingsView;
@property (weak, nonatomic) IBOutlet UILabel *reviewsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoriesLabel;

@end

@implementation YelpTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setBusiness:(Business *)business {
    _business = business;
    [YelpImageHelper setImageWithURL:business.imageURL placeHolderImage:nil forView:_profileImageView];
    [YelpImageHelper setImageWithURL:business.ratingImgURL placeHolderImage:nil forView:_ratingsView];

    [_nameLabel setText:business.name];
    [_nameLabel setPreferredMaxLayoutWidth:162.0];

    [_distanceLabel setText:[NSString stringWithFormat:@"%.2f mi", business.distance]];

    NSString * review = (business.reviewCount > 1) ? @"Reviews" : @"Review";
    [_reviewsCountLabel setText:[NSString stringWithFormat:@"%ld %@", (long)business.reviewCount, review]];

    [_addressLabel setText:business.displayAddress];
    [_addressLabel setPreferredMaxLayoutWidth:218.0];

    [_categoriesLabel setText:[business.categories componentsJoinedByString:@", "]];
    [_categoriesLabel setPreferredMaxLayoutWidth:218.0];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
