//
//  ParallaxCollectionViewCell.h
//  Revels 16
//
//  Created by Avikant Saini on 2/2/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IMAGE_HEIGHT 200
#define IMAGE_OFFSET_SPEED 15

@interface ParallaxCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsCountLabel;

/// Set imageURL before setting up placeholder image
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong, readwrite) UIImage *placeholderImage;

@property (nonatomic, assign, readwrite) CGPoint imageOffset;

@end
