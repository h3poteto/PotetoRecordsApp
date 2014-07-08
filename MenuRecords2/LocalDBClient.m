//
//  LocalDBClient.m
//  MenuRecords2
//
//  Created by akirafukushima on 2014/07/09.
//  Copyright (c) 2014年 AkiraFukushima. All rights reserved.
//

#import "LocalDBClient.h"

@implementation LocalDBClient

@synthesize dbPath = _dbPath;

- (id)init
{
    self = [super init];
    if (self) {
        NSArray     *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
        NSString    *dir = [paths objectAtIndex:0];
        _dbPath = [dir stringByAppendingPathComponent:@"menu_records.db"];
        FMDatabase  *db = [FMDatabase databaseWithPath:_dbPath];
        NSString    *sql = @"CREATE TABLE IF NOT EXISTS menulogs (id INTEGER PRIMARY KEY AUTOINCREMENT, parent_id INTEGER, name TEXT, color_tag TEXT, original_id INTEGER ,date REAL, sync BOOLEAN);";
        [db open];
        [db executeUpdate:sql];
        [db close];
    }
    return self;
}

@end
