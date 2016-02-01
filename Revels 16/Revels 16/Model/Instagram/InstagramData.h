//
//  InstagramData.h
//  Revels 16
//
//  Created by Avikant Saini on 2/1/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kInstagramDataTypeImage @"image"
#define kInstagramDataTypeVideo @"video"

@interface InstagramData : NSObject

@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) NSString *tags;

@property (nonatomic, strong) NSString *filterName;
@property (nonatomic, strong) NSURL *instagramURL;

@property (nonatomic) NSInteger commentsCount;
@property (nonatomic) NSInteger likesCount;

@property (nonatomic, strong) NSURL *thumbnailURL;
@property (nonatomic, strong) NSURL *lowResURL;
@property (nonatomic, strong) NSURL *highResURL;

@property (nonatomic, strong) NSString *captionText;

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSURL *userProfileURL;

- (instancetype)initWithData:(id)data;

+ (NSMutableArray *)getArrayFromJSONData:(id)data;

@end
