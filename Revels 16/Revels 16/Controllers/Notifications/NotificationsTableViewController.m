//
//  NotificationsTableViewController.m
//  Revels 16
//
//  Created by Avikant Saini on 2/24/16.
//  Copyright © 2016 LUG. All rights reserved.
//

#import "NotificationsTableViewController.h"

@interface NotificationsTableViewController ()

@property (strong, nonatomic) UIView *navBarBackgroundView;
@property (strong, nonatomic) UIView *bottomBackgroundView;

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

- (void)viewWillAppear:(BOOL)animated {
	
	[self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
	self.navigationController.navigationBar.shadowImage = [UIImage new];
	self.navigationController.navigationBar.translucent = YES;
	self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
	self.navigationController.view.backgroundColor = [UIColor clearColor];
	
	if (!self.navBarBackgroundView) {
		
		CGRect barRect = CGRectMake(0.0f, 0.0f, SWdith, 82.0f);
		
		self.navBarBackgroundView = [[UIView alloc] initWithFrame:barRect];
		self.navBarBackgroundView.backgroundColor = GLOBAL_BACK_COLOR;
		
		CAGradientLayer *gradientLayer = [CAGradientLayer layer];
		NSArray *colors = @[(id)[[UIColor colorWithWhite:0.8 alpha:0] CGColor],
							(id)[[UIColor colorWithWhite:1.0 alpha:1] CGColor]];
		[gradientLayer setColors:colors];
		[gradientLayer setStartPoint:CGPointMake(0.0f, 1.0f)];
		[gradientLayer setEndPoint:CGPointMake(0.0f, 0.7f)];
		[gradientLayer setFrame:[self.navBarBackgroundView bounds]];
		
		[[self.navBarBackgroundView layer] setMask:gradientLayer];
		[self.navigationController.view insertSubview:self.navBarBackgroundView belowSubview:self.navigationController.navigationBar];
	}
	
	if (!self.bottomBackgroundView) {
		
		CGRect barRect = CGRectMake(0.0f, SHeight - 32.f, SWdith, 32.0f);
		
		self.bottomBackgroundView = [[UIView alloc] initWithFrame:barRect];
		self.bottomBackgroundView.backgroundColor = GLOBAL_BACK_COLOR;
		
		CAGradientLayer *gradientLayer = [CAGradientLayer layer];
		NSArray *colors = @[(id)[[UIColor colorWithWhite:0.8 alpha:0] CGColor],
							(id)[[UIColor colorWithWhite:1.0 alpha:1] CGColor]];
		[gradientLayer setColors:colors];
		[gradientLayer setStartPoint:CGPointMake(0.0f, 0.0f)];
		[gradientLayer setEndPoint:CGPointMake(0.0f, 1.f)];
		[gradientLayer setFrame:[self.bottomBackgroundView bounds]];
		
		[[self.bottomBackgroundView layer] setMask:gradientLayer];
		[self.navigationController.view addSubview:self.bottomBackgroundView];
	}
	
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
