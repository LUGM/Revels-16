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

@implementation InstagramDetailViewController

- (void)viewDidLoad {
	
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	// Change to highRes if wifi
	[self.foregroundImageView sd_setImageWithURL:self.instaData.lowResURL placeholderImage:[UIImage imageNamed:@"image01.jpg"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//		self.backgroundImageView.image = [image applyDarkEffect];
	}];
	
	self.tagsLabel.text = self.instaData.tags;
	self.usernameLabel.text = [NSString stringWithFormat:@"@%@", self.instaData.username];
	self.likesCountLabel.text = [NSString stringWithFormat:@"%li", self.instaData.likesCount];
	self.commentsCountLabel.text = [NSString stringWithFormat:@"%li", self.instaData.commentsCount];
	self.captionTextLabel.text = self.instaData.captionText;
	
	self.crossButton.backgroundColor = [UIColor clearColor];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)dismissSelf:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
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
