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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagsLabelBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagsLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentsHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saveButtonHeightConstraint;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;


@end

@implementation InstagramDetailViewController {
	BOOL finishedDownloading;
}

- (void)viewDidLoad {
	
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	// Change to highRes if wifi
	
	self.saveButton.hidden = YES;
	self.shareButton.hidden = YES;
	
	NSURL *imageURL = self.instaData.lowResURL;
	
	if (self.reachability.currentReachabilityStatus == ReachableViaWiFi)
		imageURL = self.instaData.highResURL;
	
	[self.foregroundImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"RevelsLogo"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
		finishedDownloading = YES;
		self.shareButton.hidden = NO;
		self.saveButton.hidden = NO;
	}];
	
	self.tagsLabel.text = self.instaData.tags;
	self.usernameLabel.text = [NSString stringWithFormat:@"@%@", self.instaData.username];
	self.likesCountLabel.text = [NSString stringWithFormat:@"%li", self.instaData.likesCount];
	self.commentsCountLabel.text = [NSString stringWithFormat:@"%li", self.instaData.commentsCount];
	self.captionTextLabel.text = self.instaData.captionText;
	
	if (SHeight < 500.f) {
		self.commentsHeightConstraint.constant = 30.f;
		self.saveButtonHeightConstraint.constant = 30.f;
		self.tagsLabelBottomConstraint.constant = 8.f;
		self.tagsLabelHeightConstraint.constant = 44.f;
	}

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Share and save

- (IBAction)saveAction:(id)sender {
	if (finishedDownloading) {
		UIImageWriteToSavedPhotosAlbum(self.foregroundImageView.image, nil, nil, nil);
		SVHUD_SUCCESS(@"Saved!");
	}
}

- (IBAction)shareAction:(id)sender {
	if (finishedDownloading) {
		NSString *texttoshare = [NSString stringWithFormat:@"Check out this pic from #Revels'16 '%@'", self.instaData.captionText];
		UIImage *imagetoshare = self.foregroundImageView.image;
		NSArray *activityItems = @[texttoshare, imagetoshare];
		UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
		[self presentViewController:activityVC animated:YES completion:nil];
	}
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
