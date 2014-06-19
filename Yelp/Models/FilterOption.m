//
//  FilterOption.m
//  Yelp
//
//  Created by Veronica Zheng on 6/17/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FilterOption.h"
#import "YelpCategories.h"

static NSArray * _yelpCategories;
static NSDictionary * _yelpCategoriesDict;

@implementation FilterOption

+ (void)initialize {
    _yelpCategories = [YelpCategories categories];
    _yelpCategoriesDict = [YelpCategories categoriesDict];
}

+ (NSDictionary *)dictionaryWithFilterOption:(FilterOption *)filterOption {
    NSString * cll = [NSString stringWithFormat:@"%f,%f", filterOption.latitude, filterOption.longitude];
    NSString * deals = filterOption.dealsFilter ? @"1" : @"0";

    NSMutableDictionary * options = [@{@"term" : filterOption.term, @"location" : filterOption.location, @"cll" : cll, @"radius_filter" : [NSString stringWithFormat:@"%d", filterOption.radiusFilter], @"sort" : [NSString stringWithFormat:@"%d", filterOption.sortFilter], @"deals_filter" : deals} mutableCopy];

    if (filterOption.categories && [filterOption.categories count] > 0) {
        NSString * categoryFilter = filterOption.categoryFilterString;
        [options setObject:categoryFilter forKey:@"category_filter"];
    }
    return options;
}

- (id)init {
    self = [super init];
    if (self) {
        self.term = @"Thai";
        self.location = @"San Francisco";
        self.latitude = 37.900000;
        self.longitude = -122.500000;
        self.sortFilter= sortModeBestMatched;
        self.radiusFilter = 10000;
        self.dealsFilter = NO;
        self.categories = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *)categoryFilterString {
    NSMutableArray * categories = [[NSMutableArray alloc] init];
    for (NSNumber * number in _categories) {
        NSInteger index = [number integerValue];
        [categories addObject:_yelpCategoriesDict[_yelpCategories[index]]];
    }
    return [categories componentsJoinedByString:@","];
}

@end
