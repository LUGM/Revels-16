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
}

- (IBAction)twitterAction:(id)sender {
}

- (IBAction)instagramAction:(id)sender {
}

- (IBAction)youtubeAction:(id)sender {
}

- (IBAction)snapchatAction:(id)sender {
}

- (IBAction)browserAction:(id)sender {
}

- (IBAction)sharesheetAction:(id)sender {
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
