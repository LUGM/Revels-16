//
//  InstagramDetailViewController.h
//  Revels 16
//
//  Created by Avikant Saini on 2/1/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstagramData.h"

@interface InstagramDetailViewController : UIViewController

@property (nonatomic, strong) InstagramData *instaData;

@property (nonatomic) NSUInteger pageIndex;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *foregroundImageView;

@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionTextLabel;

@property (weak, nonatomic) IBOutlet UIButton *crossButton;


@end
