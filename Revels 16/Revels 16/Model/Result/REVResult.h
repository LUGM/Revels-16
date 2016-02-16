//
//  REVResult.h
//  Revels 16
//
//  Created by Avikant Saini on 2/16/16.
//  Copyright © 2016 LUG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface REVResult : NSObject

@property NSString *eventName;
@property NSString *categoryName;
@property NSString *resultText;

- (instancetype)initWithData:(id)data;

+ (NSMutableArray <REVResult *> *)getResultsFromJSONData:(id)data;

+ (NSMutableArray *)getCatResultsFromResults:(NSArray <REVResult *> *)results;

@end
