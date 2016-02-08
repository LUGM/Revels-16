//
//  EventHeaderTableViewCell.h
//  Revels 16
//
//  Created by Avikant Saini on 2/8/16.
//  Copyright © 2016 LUG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventHeaderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;
@property (weak, nonatomic) IBOutlet UILabel *categoryDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayDateLabel;


@end
