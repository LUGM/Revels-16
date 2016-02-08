//
//  InstagramDetailViewController.m
//  Revels 16
//
//  Created by Avikant Saini on 2/1/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

#import "InstagramDetailViewController.h"
#import "UIImage+ImageEffects.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface InstagramDetailViewController ()

@end

@implementation InstagramDetailViewController {
//	UIPanGestureRecognizer *panGestureRecognizer;
}

- (void)viewDidLoad {
	
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	// Change to highRes if wifi
	
	NSURL *imageURL = self.instaData.lowResURL;
	
	if (self.reachability.currentReachabilityStatus == ReachableViaWiFi)
		imageURL = self.instaData.highResURL;
	
	[self.foregroundImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"RevelsLogo"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//		self.backgroundImageView.image = [image applyDarkEffect];
	}];
	
	self.tagsLabel.text = self.instaData.tags;
	self.usernameLabel.text = [NSString stringWithFormat:@"@%@", self.instaData.username];
	self.likesCountLabel.text = [NSString stringWithFormat:@"%li", self.instaData.likesCount];
	self.commentsCountLabel.text = [NSString stringWithFormat:@"%li", self.instaData.commentsCount];
	self.captionTextLabel.text = self.instaData.captionText;
	
	self.crossButton.backgroundColor = [UIColor clearColor];
	
//	panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
//	panGestureRecognizer.delegate = self;
//	[self.view addGestureRecognizer:panGestureRecognizer];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)dismissSelf:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Pan gesture recognizer

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
	
	CGPoint location = [recognizer locationInView:self.view];
	
	self.view.transform = CGAffineTransformMakeTranslation(0, location.y);
	
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
