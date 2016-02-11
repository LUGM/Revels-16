//
//  EventByCategoryViewController.h
//  Revels 16
//
//  Created by Avikant Saini on 2/4/16.
//  Copyright © 2016 LUG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "REVCategory.h"

@interface EventByCategoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) REVCategory *category;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
