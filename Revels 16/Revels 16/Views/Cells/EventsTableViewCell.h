//
//  EventsTableViewCell.h
//  Revels 16
//
//  Created by Avikant Saini on 2/1/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *favsButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamInformationLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactPersonLabel;

@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;


@end
