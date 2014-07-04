//
//  WebAPIClient.h
//  MenuRecords2
//
//  Created by akirafukushima on 2014/05/29.
//  Copyright (c) 2014年 AkiraFukushima. All rights reserved.
//


#import "AFHTTPRequestOperationManager.h"


@interface WebAPIClient : AFHTTPRequestOperationManager{
    NSString    *_BASE_URL;
    NSString    *_SECRET_TOKEN;
}

+ (WebAPIClient *) sharedClient;

- (void)setEmail:(NSString *)email password:(NSString *)password;
- (void)getIndexWhenSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(int statusCode, NSString *errorString))failure
                target_file:(NSString *)target_file
                 parameters:(NSDictionary *)parameters;
- (void)postParametersWhenSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failuer:(void (^)(int statusCode, NSString * errorString))failure
                      target_file:(NSString *)target_file
                       parameters:(NSDictionary *)parameters;
- (int)statusCodeFromOperation:(AFHTTPRequestOperation *)operation;
- (NSString *)errorStringFromOperation:(AFHTTPRequestOperation *)operation;
@end
