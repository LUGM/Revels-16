//
//  CrossButton.h
//  Revels 16
//
//  Created by Avikant Saini on 2/1/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

//IB_DESIGNABLE

@interface CrossButton : UIButton

@property (strong, nonatomic) IBInspectable UIColor *fillColor;
@property IBInspectable CGFloat crossThickness;
@property IBInspectable BOOL pointyEdges;

@end
