//
//  FilterOption.m
//  Yelp
//
//  Created by Veronica Zheng on 6/17/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FilterOption.h"

@implementation FilterOption

+ (NSDictionary *)dictionaryWithFilterOption:(FilterOption *)filterOption {
    NSString * cll = [NSString stringWithFormat:@"%f,%f", filterOption.latitude, filterOption.longitude];
    NSString * deals = filterOption.dealsFilter ? @"1" : @"0";

    NSMutableDictionary * options = [@{@"term" : filterOption.term, @"location" : filterOption.location, @"cll" : cll, @"radius_filter" : [NSString stringWithFormat:@"%f", filterOption.radiusFilter], @"sort" : [NSString stringWithFormat:@"%d", filterOption.sort], @"deals_filter" : deals} mutableCopy];

    if (filterOption.categories && [filterOption.categories count] > 0) {
        NSString * categoryFilter = [filterOption.categories componentsJoinedByString:@","];
        [options setObject:categoryFilter forKey:@"category_filter"];
    }
    return options;
}

- (id)init {
    self = [super init];
    if (self) {
        self.location = @"San Francisco";
        self.latitude = 37.900000;
        self.longitude = -122.500000;
        self.sort = sortModeBestMatched;
        self.radiusFilter = 32767;
        self.dealsFilter = NO;
    }
    return self;
}

@end
