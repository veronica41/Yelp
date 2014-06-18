//
//  Business.m
//  Yelp
//
//  Created by Veronica Zheng on 6/17/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "Business.h"

@implementation Business

+ (NSArray *)businessesWithData:(id)data {
    NSMutableArray * businesses = [[NSMutableArray alloc] init];
    for (NSDictionary * entry in data[@"businesses"]) {
        Business * business = [[Business alloc] init];
        business.name = entry[@"name"];
        business.imageURL = entry[@"image_url"];
        business.ratingImgURL = entry[@"rating_img_url"];
        business.reviewCount = [entry[@"review_count"] floatValue];
        NSMutableArray * address = [entry[@"location"][@"display_address"] mutableCopy];
        if (address.count > 0) {
            [address removeObjectAtIndex:address.count-1];
        }
        business.displayAddress = [address componentsJoinedByString:@", "];
        business.distance = [entry[@"distance"] floatValue];
        NSArray * categories = entry[@"categories"];
        business.categories = [[NSMutableArray alloc] init];
        for (NSArray * category in categories) {
            [business.categories addObject:category[0]];
        }
        [businesses addObject:business];
    }
    return businesses;
}

@end
