//
//  InstagramRootViewController.h
//  Revels 16
//
//  Created by Avikant Saini on 2/3/16.
//  Copyright © 2016 LUG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstagramData.h"
#import "InstagramDetailViewController.h"

@interface InstagramRootViewController : UIViewController

@property (nonatomic, strong) UIPageViewController *pageViewController;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (nonatomic, strong) NSMutableArray <InstagramData *> *instagramObjects;
@property (nonatomic) NSInteger presentationIndex;

- (InstagramDetailViewController *)viewControllerAtIndex:(NSUInteger)index;

@end
