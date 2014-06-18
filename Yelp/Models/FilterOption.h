//
//  FilterOption.h
//  Yelp
//
//  Created by Veronica Zheng on 6/17/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    sortModeBestMatched = 0,
    sortModeDistance = 1,
    sortModeHighestRated = 2
} sortMode;

@interface FilterOption : NSObject

@property (nonatomic, strong) NSString * term;
@property (nonatomic, strong) NSString * location;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) double radiusFilter;
@property (nonatomic) sortMode sort;
@property (nonatomic) BOOL dealsFilter;
@property (nonatomic, strong) NSMutableArray * categories;

+ (NSDictionary *)dictionaryWithFilterOption:(FilterOption *)filterOption;

@end