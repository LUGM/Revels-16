//
//  AboutTableViewController.m
//  Revels 16
//
//  Created by Avikant Saini on 2/1/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

#import "AboutTableViewController.h"

@interface AboutTableViewController ()

@end

@implementation AboutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Sharing

- (IBAction)facebookAction:(id)sender {
    NSString *facebookUrlString = @"https://www.facebook.com/mitrevels/";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:facebookUrlString]];
}

- (IBAction)twitterAction:(id)sender {
    NSString *twitterUrlString = [NSString stringWithFormat:@"https:/www.twitter.com/revelsmit/"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:twitterUrlString]];
}

- (IBAction)instagramAction:(id)sender {
    NSString *instagramUrlString = [NSString stringWithFormat:@"https:/www.instagram.com/revelsmit/"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:instagramUrlString]];
}

- (IBAction)youtubeAction:(id)sender {
    NSString *youtubeUrlString = [NSString stringWithFormat:@"http:/www.bit.do/revelsyoutube"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:youtubeUrlString]];
}

- (IBAction)snapchatAction:(id)sender {
    NSString *snapchatUrlString = [NSString stringWithFormat:@"http:/www.snapchat.com/add/revelsmit/"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:snapchatUrlString]];
}

- (IBAction)browserAction:(id)sender {
    NSString *websiteUrlString = [NSString stringWithFormat:@"http://www.mitrevels.in"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:websiteUrlString]];
}

- (IBAction)sharesheetAction:(id)sender {
    NSString *websiteUrlString = [NSString stringWithFormat:@"http://www.mitrevels.in"];
    NSURL *urlToShare = [NSURL URLWithString:websiteUrlString];
    NSString *textToShare = @"Revels is one of the most awaited cultural and sports festival in the south circuit amongst the engineering colleges and is widely regarded as the largest event in Karnataka.";
    UIImage *imageToShare = [UIImage imageNamed:@"RevelsCircle"];
    NSArray *activityItems = @[imageToShare, textToShare, urlToShare];
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
