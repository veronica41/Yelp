//
//  UIColor+Yelp.m
//  Yelp
//
//  Created by Veronica Zheng on 6/16/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "UIColor+Yelp.h"

@implementation UIColor (Yelp)

+ (UIColor *)yelpRedColor {
    static UIColor * yelpRedColor = nil;
    if (!yelpRedColor){
        yelpRedColor = [UIColor colorWithRed:180/255.0 green:9/255.0 blue:4/255.0 alpha:1.0];
    }
    return yelpRedColor;
}

+ (UIColor *)yelpGrayTextColor {
    static UIColor * yelpGreyTextColor = nil;
    if (!yelpGreyTextColor){
        yelpGreyTextColor = [UIColor colorWithRed:135.0/255.0 green:141.0/255.0 blue:143.0/255.0 alpha:1.0];
    }
    return yelpGreyTextColor;
}

@end
