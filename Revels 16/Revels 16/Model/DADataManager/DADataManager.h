//
//  DADataManager.h
//  Revels 16
//
//  Created by Dark Army on 2/2/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DADataManager : NSObject

- (NSString *)documentsPathForFileName:(NSString *)name;
- (NSString *)imagesPathForFileName:(NSString *)name;

- (BOOL)saveData:(NSData *)data toDocumentsFile:(NSString *)name;
- (BOOL)saveObject:(id)object toDocumentsFile:(NSString *)name;
- (BOOL)fileExistsInDocuments:(NSString *)name;
- (id)fetchJSONFromDocumentsFileName:(NSString *)name;

+ (DADataManager *)sharedManager;

@end
