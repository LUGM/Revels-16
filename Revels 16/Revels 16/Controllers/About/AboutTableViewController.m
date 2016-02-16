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
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"https://www.facebook.com/mitrevels/"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/mitrevels/"]];
    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/mitrevels/"]];
}

- (IBAction)twitterAction:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://user?screen_name=revelsmit/"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=revelsmit/"]];
    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.twitter.com/revelsmit/"]];
}

- (IBAction)instagramAction:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"instagram://user?username=revelsmit"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"instagram://user?username=revelsmit"]];
    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.instagram.com/revelsmit/"]];
}

- (IBAction)youtubeAction:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"youtube://www.youtube.com/channel/UC9gwWd47a0q042qwEgutjWw"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"youtube://www.youtube.com/channel/UC9gwWd47a0q042qwEgutjWw"]];
    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.youtube.com/user/UC9gwWd47a0q042qwEgutjWw"]];
}

- (IBAction)snapchatAction:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"snapchat://add/revelsmit"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"snapchat://add/revelsmit"]];
    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.snapchat.com/add/revelsmit/"]];
}

- (IBAction)browserAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.mitrevels.in"]];
//    UINavigationController *navc = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterVCNav"];
//    RegisterWebViewController *wvc = [navc.viewControllers firstObject];
//    wvc.passedTitle = @"MIT Revels";
//    wvc.passedURL = [NSURL URLWithString:@"https://www.mitrevels.in"];
//    [self presentViewController:navc animated:YES completion:nil];
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