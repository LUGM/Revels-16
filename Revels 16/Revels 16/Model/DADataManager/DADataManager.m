//
//  DADataManager.m
//  Revels 16
//
//  Created by Dark Army on 2/2/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

#import "DADataManager.h"

@implementation DADataManager

- (NSString *)documentsPathForFileName:(NSString *)name {
	NSFileManager *manager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
	NSString *documentsPath = [NSString stringWithFormat:@"%@", [paths lastObject]];
	[manager createDirectoryAtPath:[NSString stringWithFormat:@"%@/com.LUG.Revels-16/Data", [paths lastObject]] withIntermediateDirectories:YES attributes:nil error:nil];
	return [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"com.LUG.Revels-16/Data/%@", name]];
}

- (NSString *)imagesPathForFileName:(NSString *)name {
	NSFileManager *manager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
	NSString *documentsPath = [NSString stringWithFormat:@"%@", [paths lastObject]];
	[manager createDirectoryAtPath:[NSString stringWithFormat:@"%@/com.LUG.Revels-16/Images", [paths lastObject]] withIntermediateDirectories:YES attributes:nil error:nil];
	return [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"com.LUG.Revels-16/Images/%@", name]];
}

- (BOOL)saveObject:(id)object toDocumentsFile:(NSString *)name {
	NSError *error;
	NSData *data = [NSJSONSerialization dataWithJSONObject:object options:kNilOptions error:&error];
	if (error == nil)
		return [self saveData:data toDocumentsFile:name];
	return NO;
}

- (BOOL)saveData:(NSData *)data toDocumentsFile:(NSString *)name {
	NSString *filePath = [self documentsPathForFileName:name];
	return [data writeToFile:filePath atomically:YES];
}

- (BOOL)fileExistsInDocuments:(NSString *)name {
	NSFileManager *manager = [NSFileManager defaultManager];
	NSString *filePath = [self documentsPathForFileName:name];
	return [manager fileExistsAtPath:filePath];
}

- (id)fetchJSONFromDocumentsFileName:(NSString *)name {
	NSError *error;
	NSString *filePath = [self documentsPathForFileName:name];
	NSData *data = [NSData dataWithContentsOfFile:filePath];
	id jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
	if (error == nil)
		return jsonData;
	return nil;
}

+ (DADataManager *)sharedManager {
	static DADataManager *sharedManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedManager = [[self alloc] init];
	});
	return sharedManager;
}

@end
