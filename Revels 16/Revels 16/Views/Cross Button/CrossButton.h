//
//  CrossButton.h
//  GRID
//
//  Created by Avikant Saini on 10/16/15.
//  Copyright © 2015 avikantz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface CrossButton : UIButton

@property (strong, nonatomic) IBInspectable UIColor *fillColor;
@property IBInspectable CGFloat crossThickness;
@property IBInspectable BOOL pointyEdges;

@end
