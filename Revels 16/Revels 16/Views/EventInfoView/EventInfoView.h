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

@protocol EventInfoViewDelegate <NSObject>

@optional

- (void)didPresentEventInfoView;
- (void)willRemoveEventInfoView;
- (void)timeButtonPressedForEvent:(REVEvent *)event;

@end

@interface EventInfoView : UIView

@property (weak, nonatomic) IBOutlet UnderlinedLabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *eventDetailsTextView;
@property (weak, nonatomic) IBOutlet UILabel *eventDateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;

@property (weak, nonatomic) UIColor *bgColor;

@property (weak, nonatomic) id<EventInfoViewDelegate> delegate;

- (IBAction)timeAction:(id)sender;
- (IBAction)phoneAction:(id)sender;

- (void)fillUsingEvent:(REVEvent *)event;

- (void)showInView:(UIView *)superview;
- (void)dismiss;

@end
