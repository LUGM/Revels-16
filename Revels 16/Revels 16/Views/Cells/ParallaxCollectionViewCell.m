//
//  ParallaxCollectionViewCell.m
//  Revels 16
//
//  Created by Avikant Saini on 2/2/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

#import "ParallaxCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ParallaxCollectionViewCell()

@property (nonatomic, strong, readwrite) UIImageView *parallaxImageView;

@end

@implementation ParallaxCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self)
		[self setupImageView];
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self)
		[self setupImageView];
	return self;
}

- (void)awakeFromNib {
	if (!self.parallaxImageView)
		[self setupImageView];
}

- (void)setupImageView {
	self.clipsToBounds = YES;
	self.parallaxImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, IMAGE_HEIGHT)];
	self.parallaxImageView.backgroundColor = [UIColor redColor];
	self.parallaxImageView.contentMode = UIViewContentModeScaleAspectFill;
	self.parallaxImageView.clipsToBounds = NO;
	[self insertSubview:self.parallaxImageView atIndex:0];
}

- (void)setPlaceholderImage:(UIImage *)placeholderImage {
	[self.parallaxImageView sd_setImageWithURL:self.imageURL placeholderImage:placeholderImage];
	[self setImageOffset:self.imageOffset];
}

- (void)setImageOffset:(CGPoint)imageOffset {
	_imageOffset = imageOffset;
	CGRect frame = self.parallaxImageView.bounds;
	CGRect offsetFrame = CGRectOffset(frame, _imageOffset.x, _imageOffset.y);
	self.parallaxImageView.frame = offsetFrame;
}

@end
