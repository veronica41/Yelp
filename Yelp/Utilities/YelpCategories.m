//
//  YelpCategories.m
//  Yelp
//
//  Created by Veronica Zheng on 6/17/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpCategories.h"

@implementation YelpCategories

- (id)init {
    self = [super init];
    if (self) {
        _categoriesDict = [[NSMutableDictionary alloc] init];
        
        NSString *fileRoot =[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:CATEGORIES_TEXT_FILE];
        NSString* fileContents = [NSString stringWithContentsOfFile:fileRoot
                                  encoding:NSUTF8StringEncoding error:nil];
        NSArray *lines = [fileContents componentsSeparatedByString:@"\n"];
        NSString * expr = @"([^()]+)";
        NSError * error;
        NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:expr options:0 error:&error];
        for (NSString * line in lines) {
            NSArray * results =  [regex matchesInString:line options:0 range:NSMakeRange(0, line.length)];
            NSString * value = [line substringWithRange:[(NSTextCheckingResult *)results[0] range]];
            NSString * key = [line substringWithRange:[(NSTextCheckingResult *)results[1] range]];
            
            [_categoriesDict setObject:value forKey:key];
        }
    }
    return self;
}

@end
