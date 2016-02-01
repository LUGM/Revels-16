//
//  InstagramViewController.m
//  Revels 16
//
//  Created by Avikant Saini on 2/1/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

#import "InstagramViewController.h"
#import "InstagramData.h"
#import "InstagramDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface InstagramViewController ()

@end

@implementation InstagramViewController {
	NSMutableArray *instagramObjects;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Setup instagram...
	
	self.featureHeight = SWdith;
	self.collapsedHeight = SWdith/3;
	
	instagramObjects = [NSMutableArray new];
	
	SVHUD_SHOW;
	
	NSString *URLString = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=fd6b3100174e42d7aa7d546574e01c76", kTagToSearch];
	
	NSURL *URL = [NSURL URLWithString:URLString];
	
	ASMutableURLRequest *request = [ASMutableURLRequest getRequestWithURL:URL];
	
	[[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		
		if (error) {
			SVHUD_FAILURE(@"Error!");
			return;
		}
		
		PRINT_RESPONSE_HEADERS_AND_CODE;
		
		id jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
		
		if (statusCode == 200) {
			
			id imagesJSON = [jsonData valueForKey:@"data"];
			NSArray *imagesArray = [InstagramData getArrayFromJSONData:imagesJSON];
			
			[instagramObjects addObjectsFromArray:imagesArray];
			
			dispatch_async(dispatch_get_main_queue(), ^{
				[self.collectionView reloadData];
				[self.collectionView reloadInputViews];
				SVHUD_HIDE;
			});
			
		}
		
	}] resume];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RPSlidingMenuViewController


- (NSInteger)numberOfItemsInSlidingMenu {
	return instagramObjects.count;
}

- (void)customizeCell:(RPSlidingMenuCell *)slidingMenuCell forRow:(NSInteger)row {
	
	InstagramData *instaData = [instagramObjects objectAtIndex:row];
	
	slidingMenuCell.detailTextLabel.text = instaData.tags;
	[slidingMenuCell.backgroundImageView sd_setImageWithURL:instaData.lowResURL placeholderImage:[UIImage imageNamed:@"image01.jpg"]];
	
	slidingMenuCell.leftSideLabel.text = [NSString stringWithFormat:@"%li", instaData.likesCount];
	slidingMenuCell.rightSideLabel.text = [NSString stringWithFormat:@"%li", instaData.commentsCount];
	
	slidingMenuCell.textLabel.text = @"";
}

- (void)slidingMenu:(RPSlidingMenuViewController *)slidingMenu didSelectItemAtRow:(NSInteger)row {
	
	[super slidingMenu:slidingMenu didSelectItemAtRow:row];
	
	InstagramData *instaData = [instagramObjects objectAtIndex:row];
	
	InstagramDetailViewController *idvc = [self.storyboard instantiateViewControllerWithIdentifier:@"InstagramDetailVC"];
	idvc.instaData = instaData;
	[self presentViewController:idvc animated:YES completion:nil];
	
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
