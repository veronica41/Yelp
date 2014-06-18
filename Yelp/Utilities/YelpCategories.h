//
//  YelpCategories.h
//  Yelp
//
//  Created by Veronica Zheng on 6/17/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CATEGORIES_TEXT_FILE @"categories.txt"

@interface YelpCategories : NSObject

/*
 key is the human readable category, value is the category_filter
 */
@property (nonatomic, strong) NSMutableDictionary * categoriesDict;

@end
