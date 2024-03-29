//
//  WebAPIClient.m
//  MenuRecords2
//
//  Created by akirafukushima on 2014/05/29.
//  Copyright (c) 2014年 AkiraFukushima. All rights reserved.
//

#import "WebAPIClient.h"

@implementation WebAPIClient

static WebAPIClient *_sharedClient;
+ (WebAPIClient *)sharedClient
{
    if (!_sharedClient) {
        _sharedClient = [[WebAPIClient alloc]init];
    }
    
    return _sharedClient;
}

- (id) init
{
    _SECRET_TOKEN = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"SecretToken"];
    _BASE_URL = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"BaseUrl"];
    if (self = [super initWithBaseURL:[NSURL URLWithString:_BASE_URL]]) {
        
    }
    return self;
}

- (void)setEmail:(NSString *)email password:(NSString *)password
{
    [self setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [self.requestSerializer setAuthorizationHeaderFieldWithUsername:email password:password];
    
    // mail passはdbにも保存しておきたい
    // 普通はkey chainに入れるらしい

}

//=========================================
//  get method
//=========================================
- (void)getIndexWhenSuccess:(void (^)(AFHTTPRequestOperation *, id))success
                    failure:(void (^)(int, NSString *))failure
                target_file:(NSString *)target_file
                 parameters:(NSDictionary *)parameters
{
    NSMutableDictionary    *params = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [params setObject:_SECRET_TOKEN forKey:@"token"];
    
    [self   GET:target_file
            parameters:params
            success:success
            failure:^(AFHTTPRequestOperation *operation, NSError *error){
                failure([self statusCodeFromOperation:operation], [self errorStringFromOperation:operation]);
            }];
}

//=========================================
//  post method
//=========================================
- (void)postParametersWhenSuccess:(void (^)(AFHTTPRequestOperation *, id))success
                          failuer:(void (^)(int, NSString *))failure
                      target_file:(NSString *)target_file
                       parameters:(NSDictionary *)parameters
{
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [params setObject:_SECRET_TOKEN forKey:@"token"];
    
    [self   POST:target_file
      parameters:params
         success:success
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             failure([self statusCodeFromOperation:operation], [self errorStringFromOperation:operation]);
         }];
     
}

//=========================================
//  Helper Methods
//=========================================
- (int)statusCodeFromOperation:(AFHTTPRequestOperation *)operation
{
    return  operation.response.statusCode;
}

- (NSString *)errorStringFromOperation:(AFHTTPRequestOperation *)operation
{
    NSError     *error = nil;
    NSString    *result = nil;
    
    if (operation.responseData){
        result = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:&error];
    }else{
        result = @"Connection Error";
    }
    
    return result;
}
@end
