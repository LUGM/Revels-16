//
//  EventByCategoryViewController.m
//  Revels 16
//
//  Created by Avikant Saini on 2/4/16.
//  Copyright © 2016 LUG. All rights reserved.
//

#import "EventByCategoryViewController.h"
#import "EventsTableViewCell.h"
#import "EventHeaderTableViewCell.h"
#import "REVEvent.h"

@interface EventByCategoryViewController () 

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation EventByCategoryViewController {
	NSMutableArray *events;
	NSMutableArray *filteredEvents;
	NSManagedObjectContext *managedObjectContext;
	NSFetchRequest *fetchRequest;
	NSInteger currentSegmentedIndex;
	
	UISwipeGestureRecognizer *leftSwipeGesture;
	UISwipeGestureRecognizer *rightSwipeGesture;
	
	BOOL headerViewShown;
	
	NSInteger fetchCount;
	
	UITapGestureRecognizer *sectionTapGesture;
	CGFloat headerHeight;
}

- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	events = [NSMutableArray new];
	filteredEvents = [NSMutableArray new];
	
	self.selectedIndexPath = nil;
	currentSegmentedIndex = 0;
	
	fetchCount = 0;
	
	managedObjectContext = [AppDelegate managedObjectContext];
	fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"REVEvent"];
	if (self.category)
		[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"catID == %@", self.category.uid]];
	
	[self fetchFilteredEvents];
	
	[self.segmentedControl setTintColor:[UIColor blackColor]];
	
	[self.navigationController.navigationBar setTranslucent:NO];
	[self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];
	[self.navigationController.navigationBar setBackgroundColor:GLOBAL_BACK_COLOR];
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Pixel"] forBarMetrics:UIBarMetricsDefault];
	
	self.navigationItem.title = self.category.name;
	
	leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
	[leftSwipeGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
	[self.view addGestureRecognizer:leftSwipeGesture];
	
	rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
	[rightSwipeGesture setDirection:UISwipeGestureRecognizerDirectionRight];
	[self.view addGestureRecognizer:rightSwipeGesture];
	
	headerViewShown = (SWdith > 360);
	
	sectionTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
	headerHeight = 80.f;

}

- (IBAction)dismissSelf:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)fetchFilteredEvents {
	NSError *error;
	events = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
	filteredEvents = [NSMutableArray arrayWithArray:events];
	if (error)
		NSLog(@"Error in fetching: %@", error.localizedDescription);
	[self filterEventsForSelectedSegmentTitle:[self.segmentedControl titleForSegmentAtIndex:currentSegmentedIndex]];
	
	if (filteredEvents.count < 1 && fetchCount < 2) {
		Reachability *reachability = [Reachability reachabilityForInternetConnection];
		if ([reachability isReachable])
			[self fetchEvents];
		else {
			SVHUD_FAILURE(@"No Connection!")
			[self dismissSelf:nil];
		}
		fetchCount++;
	}
	if (fetchCount == 2) {
		SVHUD_FAILURE(@"Failed!");
		// Display more information as toast?
		[self dismissSelf:nil];
	}
}

- (void)fetchEvents {
	
	SVHUD_SHOW;
	
	NSURL *eventsUrl = [NSURL URLWithString:@"http://api.mitportals.in"];
	
	ASMutableURLRequest *postRequest = [ASMutableURLRequest postRequestWithURL:eventsUrl];
	NSString *post = [NSString stringWithFormat:@"secret=%@", @"LUGbatchof2017"];
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	[postRequest setHTTPBody:postData];
	
	[[[NSURLSession sharedSession] dataTaskWithRequest:postRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		
		if (error) {
			SVHUD_FAILURE(@"Error!");
			return;
		}
		
		PRINT_RESPONSE_HEADERS_AND_CODE;
		
		id jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
		
		if (error == nil && statusCode == 200) {
			NSMutableArray *evnts = [REVEvent getEventsFromJSONData:[jsonData objectForKey:@"data"] storeIntoManagedObjectContext:managedObjectContext];
			dispatch_async(dispatch_get_main_queue(), ^{
				[self fetchEventSchedule];
				events = [NSMutableArray arrayWithArray:evnts];
			});
		}
		
	}] resume];
	
}

- (void)fetchEventSchedule {
	
	NSURL *eventsUrl = [NSURL URLWithString:@"http://schedule.mitportals.in"];
	
	ASMutableURLRequest *postRequest = [ASMutableURLRequest postRequestWithURL:eventsUrl];
	NSString *post = [NSString stringWithFormat:@"secret=%@", @"revels16Dastaan"];
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	[postRequest setHTTPBody:postData];
	
	[[[NSURLSession sharedSession] dataTaskWithRequest:postRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		
		if (error) {
			SVHUD_FAILURE(@"Error!");
			return;
		}
		
		PRINT_RESPONSE_HEADERS_AND_CODE;
		
		id jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
		
		if (error == nil && statusCode == 200) {
			NSMutableArray *evnts = [REVEvent eventsAfterUpdatingScheduleFromJSONData:[jsonData valueForKey:@"data"] inManagedObjectContext:managedObjectContext];
			dispatch_async(dispatch_get_main_queue(), ^{
				events = [NSMutableArray arrayWithArray:evnts];
				[self fetchFilteredEvents];
			});
		}
		
		SVHUD_HIDE;
		
	}] resume];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentedControlValueChanged:(id)sender {
	
	self.selectedIndexPath = nil;
	
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	NSInteger index = segmentedControl.selectedSegmentIndex;
	
	NSInteger direction = 1;
	if (index < currentSegmentedIndex)
		direction = -1;
	
	[UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		self.tableView.layer.transform = CATransform3DMakeTranslation(- direction * (SWdith + 40), 0, 0);
		self.tableView.alpha = 0.5;
	} completion:^(BOOL finished) {
		self.tableView.layer.transform = CATransform3DMakeTranslation(direction * (SWdith + 40), 0, 0);
		[self filterEventsForSelectedSegmentTitle:[segmentedControl titleForSegmentAtIndex:index]];
		[UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
			self.tableView.layer.transform = CATransform3DIdentity;
			self.tableView.alpha = 1.f;
		} completion:nil];
	}];
	
	currentSegmentedIndex = index;
	
}

- (IBAction)toggleHeaderView:(id)sender {
	headerViewShown = !headerViewShown;
	[self.tableView reloadData];
}


#pragma mark - Swipe gesture handler

- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)recognizer {
	
	NSInteger direction = 1;
	NSInteger index = currentSegmentedIndex;
	NSInteger newIndex = (index == 0)?3:(index - 1);
	
	if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
		direction = -1;
		newIndex = (index == 3)?0:(index + 1);
	}
	
	[UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		self.tableView.layer.transform = CATransform3DMakeTranslation(- direction * (SWdith + 40), 0, 0);
		self.tableView.alpha = 0.5;
	} completion:^(BOOL finished) {
		self.tableView.layer.transform = CATransform3DMakeTranslation(direction * (SWdith + 40), 0, 0);
		self.segmentedControl.selectedSegmentIndex = newIndex;
		[self filterEventsForSelectedSegmentTitle:[self.segmentedControl titleForSegmentAtIndex:newIndex]];
		currentSegmentedIndex = newIndex;
		[UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
			self.tableView.layer.transform = CATransform3DIdentity;
			self.tableView.alpha = 1.f;
		} completion:nil];
	}];
	
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return filteredEvents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	REVEvent *event = [filteredEvents objectAtIndex:indexPath.row];
	
	EventsTableViewCell *cell;
 
	if ([indexPath compare:self.selectedIndexPath] == NSOrderedSame)
		cell = (EventsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"eventsCellExp" forIndexPath:indexPath];
	else
		cell = (EventsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"eventsCell" forIndexPath:indexPath];
	
	if (cell == nil)
		cell = [[EventsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"eventsCell"];
	
	cell.eventNameLabel.text = event.name;
	cell.categoryNameLabel.text = event.detail;
	
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	EventHeaderTableViewCell *cell = (EventHeaderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"eventsCellHeader"];
	
	if (cell == nil)
		cell = [[EventHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"eventsCellHeader"];
	
	cell.categoryDescriptionLabel.text = self.category.detail;
//	cell.categoryImageView.image = [UIImage imageNamed:self.category.imageName];
	cell.categoryImageView.image = [UIImage imageNamed:@"eventsIcon"];
	
	NSDateFormatter *formatter = [NSDateFormatter new];
	[formatter setDateFormat:@"EEE, MMMM dd, yyyy"];
	
	[cell addGestureRecognizer:sectionTapGesture];
	
	REVEvent *event = [filteredEvents firstObject];
	if (event)
		cell.dayDateLabel.text = [formatter stringFromDate:event.startDate];
	else
		cell.dayDateLabel.text = [self.segmentedControl titleForSegmentAtIndex:self.segmentedControl.selectedSegmentIndex];
	
	return cell;
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
	[self.tableView beginUpdates];
	if (headerHeight == 80.f)
		headerHeight = 160.f;
	else
		headerHeight = 80.f;
	[self.tableView endUpdates];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self.tableView reloadData];
	});
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//	CGRect rect = [self.category.detail boundingRectWithSize:CGSizeMake(SWdith - 120, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.f]} context:nil];
	return headerViewShown * headerHeight;
}

#pragma mark - Cell button actions

- (void)infoButtonPressed:(id)sender {
	//	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
	
	//	REVEvent *event = [filteredEvents objectAtIndex:indexPath.row];
	
	// Show awesome alert...
}

- (void)favsButtonPressed:(id)sender {
	
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
	
	REVEvent *event = [filteredEvents objectAtIndex:indexPath.row];
	event.isFavourite = !event.isFavourite;
	
	NSError *error;
	if (![managedObjectContext save:&error])
		NSLog(@"Can't Save : %@, %@", error, [error localizedDescription]);
	
	[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)timeButtonPressed:(id)sender {
	// Prompt adding an event
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
	NSLog(@"Time tapped for row: %li", indexPath.row);
}

- (void)phoneButtonPressed:(id)sender {
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
	NSLog(@"Phone tapped for row: %li", indexPath.row);
}

#pragma mark - Filtering

- (void)filterEventsForSelectedSegmentTitle:(NSString *)segmentTitle {
	filteredEvents = [NSMutableArray arrayWithArray:events];
	[filteredEvents filterUsingPredicate:[NSPredicate predicateWithFormat:@"day == %@", segmentTitle]];
	[self.tableView reloadData];
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
