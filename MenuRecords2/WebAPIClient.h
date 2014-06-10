//
//  WebAPIClient.h
//  MenuRecords2
//
//  Created by akirafukushima on 2014/05/29.
//  Copyright (c) 2014年 AkiraFukushima. All rights reserved.
//

#define BASE_URL @"http://192.168.33.10:3000/"
#define SECRET_TOKEN @"token"

#import "AFHTTPRequestOperationManager.h"

@interface WebAPIClient : AFHTTPRequestOperationManager

+ (WebAPIClient *) sharedClient;

- (void)setEmail:(NSString *)email password:(NSString *)password;
- (void)getIndexWhenSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(int statusCode, NSString *errorString))failure
                target_file:(NSString *)target_file
                 parameters:(NSDictionary *)parameters;
- (int)statusCodeFromOperation:(AFHTTPRequestOperation *)operation;
- (NSString *)errorStringFromOperation:(AFHTTPRequestOperation *)operation;
@end
