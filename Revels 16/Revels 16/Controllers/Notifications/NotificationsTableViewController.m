//
//  NotificationsTableViewController.m
//  Revels 16
//
//  Created by Avikant Saini on 2/24/16.
//  Copyright © 2016 LUG. All rights reserved.
//

#import "NotificationsTableViewController.h"

@interface NotificationsTableViewController ()

@end

@implementation NotificationsTableViewController {
	NSMutableArray *notifs;
}

- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	notifs = [NSMutableArray new];
	
	SVHUD_SHOW;
	
	PFQuery *query = [PFQuery queryWithClassName:@"Notifications"];
	[query orderByAscending:@"createdAt"];
	[query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
		
		if (error) {
			SVHUD_FAILURE(error.localizedDescription);
			return;
		}
		
		notifs = [NSMutableArray arrayWithArray:objects];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.tableView reloadData];
			SVHUD_HIDE;
		});
		
	}];
	
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RevelsCutout"]];
	[imageView setFrame:CGRectMake(0, 0, SWdith, 80.f)];
	[imageView setContentMode:UIViewContentModeScaleAspectFit];
	
	self.tableView.tableHeaderView = imageView;
	
}

- (IBAction)dismissAction:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return notifs.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notificationCell" forIndexPath:indexPath];
	
	PFObject *notif = [notifs objectAtIndex:indexPath.section];
	
	cell.textLabel.text = [notif objectForKey:@"detail"];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	PFObject *notif = [notifs objectAtIndex:section];
	
	return [notif objectForKey:@"title"];
	
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
