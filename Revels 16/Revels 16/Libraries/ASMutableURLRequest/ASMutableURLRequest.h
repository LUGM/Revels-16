//
//  ASMutableURLRequest.h
//  Revels 16
//
//  Created by Avikant Saini on 2/1/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASMutableURLRequest : NSMutableURLRequest

+ (instancetype)getRequestWithURL:(NSURL *)URL;
+ (instancetype)postRequestWithURL:(NSURL *)URL;
+ (instancetype)putRequestWithURL:(NSURL *)URL;
+ (instancetype)deleteRequestWithURL:(NSURL *)URL;

@end
