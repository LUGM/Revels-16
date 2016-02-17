//
//  AboutTableViewController.m
//  Revels 16
//
//  Created by Avikant Saini on 2/1/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

#import "AboutTableViewController.h"
#import "RegisterWebViewController.h"

@interface AboutTableViewController ()

@end

@implementation AboutTableViewController {
	Reachability *reachability;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem.
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Sharing

- (void)openURLWithString:(NSString *)URLString backupURLString:(NSString *)backupURLString {
	reachability = [Reachability reachabilityForInternetConnection];
	if (reachability.isReachable) {
		if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:URLString]])
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
		else
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:backupURLString]];
	}
	else {
		SVHUD_FAILURE(@"No connection!");
	}
}

- (IBAction)facebookAction:(id)sender {
	[self openURLWithString:@"https://www.facebook.com/mitrevels/" backupURLString:@"https://www.facebook.com/mitrevels/"];
}

- (IBAction)twitterAction:(id)sender {
	[self openURLWithString:@"twitter://user?screen_name=revelsmit/" backupURLString:@"https://www.twitter.com/revelsmit/"];
}

- (IBAction)instagramAction:(id)sender {
	[self openURLWithString:@"instagram://user?username=revelsmit" backupURLString:@"https://www.instagram.com/revelsmit/"];
}

- (IBAction)youtubeAction:(id)sender {
	[self openURLWithString:@"youtube://www.youtube.com/channel/UC9gwWd47a0q042qwEgutjWw" backupURLString:@"http://www.youtube.com/user/UC9gwWd47a0q042qwEgutjWw"];
}

- (IBAction)snapchatAction:(id)sender {
	[self openURLWithString:@"snapchat://add/revelsmit" backupURLString:@"http://www.snapchat.com/add/revelsmit/"];
}

- (IBAction)browserAction:(id)sender {
	[self openURLWithString:@"https://www.mitrevels.in" backupURLString:@"https://www.mitrevels.in"];
}

- (IBAction)sharesheetAction:(id)sender {
    NSURL *urlToShare = [NSURL URLWithString:@"https://www.mitrevels.in"];
    NSString *textToShare = @"Revels is one of the most awaited cultural and sports festival in the south circuit amongst the engineering colleges and is widely regarded as the largest event in Karnataka.";
    //    UIImage *imageToShare = [UIImage imageNamed:@"RevelsCircle"];
    NSArray *activityItems = @[textToShare, urlToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}


#pragma mark - Table view data source

#pragma mark - Table view delegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Navigation

- (IBAction)dismissAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end