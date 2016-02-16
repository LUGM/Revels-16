//
//  EventInfoView.h
//  Revels 16
//
//  Created by Avikant Saini on 2/11/16.
//  Copyright © 2016 LUG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnderlinedLabel.h"
#import "REVEvent.h"

@interface EventInfoView : UIView

@property (weak, nonatomic) IBOutlet UnderlinedLabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *eventDetailsTextView;
@property (weak, nonatomic) IBOutlet UILabel *eventDateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;

@property (weak, nonatomic) UIColor *bgColor;

- (IBAction)timeAction:(id)sender;
- (IBAction)phoneAction:(id)sender;

- (void)fillUsingEvent:(REVEvent *)event;

- (void)showInView:(UIView *)superview;
- (void)dismiss;

@end
