//
//  FavouritesTableViewController.m
//  Revels 16
//
//  Created by Avikant Saini on 2/1/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

#import "FavouritesTableViewController.h"
#import "EventsTableViewCell.h"
#import "EventInfoView.h"
#import "REVEvent.h"

@interface FavouritesTableViewController () <EKEventViewDelegate>

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation FavouritesTableViewController {
	NSMutableArray *events;
	NSManagedObjectContext *managedObjectContext;
	NSFetchRequest *fetchRequest;
	
	NSArray <UIColor *> *cellBackgroundColors;
	
	EventInfoView *eventInfoView;
	UITapGestureRecognizer *tapGestureRecognizer;
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	events = [NSMutableArray new];
	
	self.selectedIndexPath = nil;
	
	managedObjectContext = [AppDelegate managedObjectContext];
	fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"REVEvent"];
	[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"favourite == 1"]];
	
	cellBackgroundColors = [UIColor revelsColors];
	
	eventInfoView = [[[NSBundle mainBundle] loadNibNamed:@"EventInfoView" owner:self options:nil] firstObject];
	tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
	
	[self fetchFavourites];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchFavourites {
	NSError *error;
	events = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
	if (error)
		NSLog(@"Error in fetching: %@", error.localizedDescription);
	[self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return events.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	REVEvent *event = [events objectAtIndex:indexPath.row];
	
	EventsTableViewCell *cell;
 
	if ([indexPath compare:self.selectedIndexPath] == NSOrderedSame)
		cell = (EventsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"eventsCellExp" forIndexPath:indexPath];
	else
		cell = (EventsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"eventsCell" forIndexPath:indexPath];
	
	if (cell == nil)
		cell = [[EventsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"eventsCell"];
	
	cell.eventNameLabel.text = event.name;
	cell.categoryNameLabel.text = event.categoryName;
	
	[cell.infoButton setTag:indexPath.row];
	[cell.infoButton addTarget:self action:@selector(infoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	if (event.isFavourite)
		[cell.favsButton setImage:[UIImage imageNamed:@"favsFilled"] forState:UIControlStateNormal];
	else
		[cell.favsButton setImage:[UIImage imageNamed:@"favsEmpty"] forState:UIControlStateNormal];
	
	[cell.favsButton setTag:indexPath.row];
	[cell.favsButton addTarget:self action:@selector(favsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	cell.dateLabel.text = event.dateString;
	cell.timeLabel.text = event.timeString;
	cell.venueNameLabel.text = event.venue;
	cell.teamInformationLabel.text = [NSString stringWithFormat:@"Maximum team members: %@", event.maxTeamNo];
	cell.contactPersonLabel.text = event.contactName;
	
	[cell.timeButton setTag:indexPath.row];
	[cell.timeButton addTarget:self action:@selector(timeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	[cell.phoneButton setTag:indexPath.row];
	[cell.phoneButton addTarget:self action:@selector(phoneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	cell.backgroundColor = [cellBackgroundColors objectAtIndex:indexPath.row % cellBackgroundColors.count];
	
	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView beginUpdates];
	
	if (![indexPath compare:self.selectedIndexPath] == NSOrderedSame)
		self.selectedIndexPath = indexPath;
	else
		self.selectedIndexPath = nil;
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
	});
	
	[tableView endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([indexPath compare:self.selectedIndexPath] == NSOrderedSame)
		return 228.f;
	return 60.f;
}

#pragma mark - Cell button actions

- (void)infoButtonPressed:(id)sender {
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
	REVEvent *event = [events objectAtIndex:indexPath.row];
	
	[eventInfoView fillUsingEvent:event];
	[eventInfoView showInView:self.navigationController.view];
	
	[self.view addGestureRecognizer:tapGestureRecognizer];
}


- (void)favsButtonPressed:(id)sender {
	
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
	
	REVEvent *event = [events objectAtIndex:indexPath.row];
	event.isFavourite = !event.isFavourite;
	
	NSError *error;
	if (![managedObjectContext save:&error])
		NSLog(@"Can't Save : %@, %@", error, [error localizedDescription]);
	
	[events removeObject:event];
	[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self.tableView reloadData];
	});
}

- (void)timeButtonPressed:(id)sender {
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
	
	REVEvent *event = [events objectAtIndex:indexPath.row];
	
	EKEventStore *ekEventStore = [[EKEventStore alloc] init];
	EKEvent *ekEvent = [EKEvent eventWithEventStore:ekEventStore];
	
	if (!([EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent] == EKAuthorizationStatusAuthorized)) {
		[ekEventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
			if (!granted) {
				SVHUD_FAILURE(@"Access denied!");
				return;
			}
		}];
	}
	
	ekEvent.title = event.name;
	ekEvent.startDate = event.startDate;
	ekEvent.endDate = event.endDate;
	ekEvent.location = event.venue;
	
	[ekEvent setCalendar:[ekEventStore defaultCalendarForNewEvents]];
	
	EKEventViewController *eventViewController = [[EKEventViewController alloc] init];
	eventViewController.event = ekEvent;
	eventViewController.allowsEditing = YES;
	eventViewController.delegate = self;
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:eventViewController];
	[self presentViewController:navigationController animated:YES completion:nil];
}

- (void)phoneButtonPressed:(id)sender {
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
	REVEvent *event = [events objectAtIndex:indexPath.row];
	NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", event.contactPhone]];
	[[UIApplication sharedApplication] openURL:phoneURL];
}

#pragma mark - Tap gesture handler

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
	
	[eventInfoView dismiss];
	[self.view removeGestureRecognizer:tapGestureRecognizer];
	
}

#pragma mark - Event kit view delegate

- (void)eventViewController:(EKEventViewController *)controller didCompleteWithAction:(EKEventViewAction)action {
	
	if (action == EKEventViewActionDone) {
		SVHUD_SUCCESS(@"Event saved!");
	}
	else if (action == EKEventViewActionDeleted) {
//		SVHUD_FAILURE(@"Event saving failed!");
	}
	
	[self dismissViewControllerAnimated:YES completion:nil];
	
}


#pragma mark - Navigation

- (IBAction)dismissAction:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}


@end
