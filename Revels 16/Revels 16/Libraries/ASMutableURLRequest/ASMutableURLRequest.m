//
//  ASMutableURLRequest.m
//  Revels 16
//
//  Created by Avikant Saini on 2/1/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

#import "ASMutableURLRequest.h"

@implementation ASMutableURLRequest

+ (instancetype)requestWithURL:(NSURL *)URL {
	ASMutableURLRequest *request = [super requestWithURL:URL];
	return request;
}

+ (instancetype)getRequestWithURL:(NSURL *)URL {
	ASMutableURLRequest *request = [ASMutableURLRequest requestWithURL:URL];
	[request setHTTPMethod:@"GET"];
	return request;
}

+ (instancetype)postRequestWithURL:(NSURL *)URL {
	ASMutableURLRequest *request = [ASMutableURLRequest requestWithURL:URL];
	[request setHTTPMethod:@"POST"];
	return request;
}

+ (instancetype)putRequestWithURL:(NSURL *)URL {
	ASMutableURLRequest *request = [ASMutableURLRequest requestWithURL:URL];
	[request setHTTPMethod:@"PUT"];
	return request;
}

+ (instancetype)deleteRequestWithURL:(NSURL *)URL {
	ASMutableURLRequest *request = [ASMutableURLRequest requestWithURL:URL];
	[request setHTTPMethod:@"DELETE"];
	return request;
}

@end
