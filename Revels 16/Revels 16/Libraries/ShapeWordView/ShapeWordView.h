//
//  ShapeWordView.h
//  PathWord
//
//  Created by XianMingYou on 15/3/6.
//  Copyright (c) 2015年 XianMingYou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBezierPath+TextPaths.h"

@interface ShapeWordView : UIView


@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIFont   *font;
@property (nonatomic, strong) UIColor  *lineColor;
@property (nonatomic, assign) CGFloat   lineWidth;

- (void)buildView;

- (void)percent:(CGFloat)percent animated:(BOOL)animated;


@end
