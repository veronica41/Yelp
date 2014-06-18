//
//  YelpClient.h
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDBOAuth1RequestOperationManager.h"
#import "FilterOption.h"

@interface YelpClient : BDBOAuth1RequestOperationManager

- (AFHTTPRequestOperation *)searchWithFilterOption:(FilterOption *)filterOption success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
