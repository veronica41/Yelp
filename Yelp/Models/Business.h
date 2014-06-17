//
//  Business.h
//  Yelp
//
//  Created by Veronica Zheng on 6/17/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Business : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * imageURL;
@property (nonatomic, strong) NSString * ratingImgURL;
@property (nonatomic) NSInteger reviewCount;
@property (nonatomic, strong) NSString * displayAddress;
@property (nonatomic) CGFloat distance;
@property (nonatomic, strong) NSMutableArray * categories;

+ (NSArray *)businessesWithData:(id)data;

@end
