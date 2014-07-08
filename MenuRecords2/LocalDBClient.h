//
//  LocalDBClient.h
//  MenuRecords2
//
//  Created by akirafukushima on 2014/07/09.
//  Copyright (c) 2014年 AkiraFukushima. All rights reserved.
//

#import "FMDatabase.h"

@interface LocalDBClient : FMDatabase{
    NSString    *_dbPath;
}
@property (strong, nonatomic) NSString  *dbPath;

@end
