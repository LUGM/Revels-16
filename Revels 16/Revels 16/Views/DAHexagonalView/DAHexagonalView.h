//
//  DAHexagonalView.h
//  Revels 16
//
//  Created by Avikant Saini on 2/5/16.
//  Copyright © 2016 LUG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

IB_DESIGNABLE

@protocol DAHexagonalViewDelegate <NSObject>

- (void)hexagonalViewButtonPressedAtIndex:(NSInteger)index;
- (void)finishedAllAnimationsDoSomethingAwesome;

@end

@interface DAHexagonalView : UIView

@property (nonatomic, strong) NSMutableArray *startPoints;
@property (nonatomic, strong) NSMutableArray *entryPoints;
@property (nonatomic, strong) NSMutableArray *hexPoints;
@property (nonatomic, strong) NSMutableArray *exitPoints;

@property (nonatomic, strong) NSMutableArray <UIImage *> *images;

@property (nonatomic, weak) id<DAHexagonalViewDelegate> delegate;

- (void)animatePath;

- (void)removeAllAnimations;

@end
