//
//  REVCategory.h
//  Revels 16
//
//  Created by Avikant Saini on 2/2/16.
//  Copyright © 2016 LUG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface REVCategory : NSObject

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *imageName;
//@property (nonatomic, strong) NSString *type;

- (instancetype)initWithDict:(id)dict;

+ (NSMutableArray <REVCategory *> *)getArrayFromJSONData:(id)data;

@end
