//
//  EventsListViewController.m
//  Revels 16
//
//  Created by Avikant Saini on 2/1/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

#import "EventsListViewController.h"
#import "EventsTableViewCell.h"
#import "REVEvent.h"

@interface EventsListViewController () <UISearchResultsUpdating, UISearchBarDelegate>

@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation EventsListViewController {
	NSMutableArray *events;
	NSMutableArray *filteredEvents;
	NSManagedObjectContext *managedObjectContext;
	NSFetchRequest *fetchRequest;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	events = [NSMutableArray new];
	filteredEvents = [NSMutableArray new];
	
	managedObjectContext = [AppDelegate managedObjectContext];
	fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"REVEvent"];
	
	[self fetchLocalEvents];
	
	// If connected to internet...
	[self fetchEvents];
	
	[self setupSearchController];
	
	[self.segmentedControl setTintColor:[UIColor brownColor]];
	[self.navigationController.navigationBar setTranslucent:NO];
	[self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];
	[self.navigationController.navigationBar setBackgroundColor:GLOBAL_BACK_COLOR];
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Pixel"] forBarMetrics:UIBarMetricsDefault];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchEvents {
	
	SVHUD_SHOW;
	
	NSURL *eventsURL = [NSURL URLWithString:@"http://schedule.techtatva.in/"];
	
	ASMutableURLRequest *request = [ASMutableURLRequest getRequestWithURL:eventsURL];
	
	[[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		
		if (error) {
			// Fetch local data?
			SVHUD_FAILURE(@"Error!");
			return;
		}
		
		PRINT_RESPONSE_HEADERS_AND_CODE;
		
		id jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
		
		if (error == nil && statusCode == 200) {
			NSMutableArray *evnts = [REVEvent getEventsFromJSONData:[jsonData valueForKey:@"data"] storeIntoManagedObjectContext:managedObjectContext];
			dispatch_async(dispatch_get_main_queue(), ^{
				events = [NSMutableArray arrayWithArray:evnts];
				[self filterEventsForSelectedSegmentTitle:[self.segmentedControl titleForSegmentAtIndex:self.segmentedControl.selectedSegmentIndex]];
			});
		}
		
		SVHUD_HIDE;
		
	}] resume];
	
}

- (void)fetchLocalEvents {
	NSError *error;
	events = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
	if (error)
		NSLog(@"Error in fetching: %@", error.localizedDescription);
	[self filterEventsForSelectedSegmentTitle:[self.segmentedControl titleForSegmentAtIndex:self.segmentedControl.selectedSegmentIndex]];
}

- (void)setupSearchController {
	self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
	self.searchController.searchResultsUpdater = self;
	self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
//	self.searchController.searchBar.scopeButtonTitles = @[@"Day 1", @"Day 2", @"Day 3", @"Day 4", @"Day 5"];
	self.searchController.searchBar.delegate = self;
	self.searchController.searchBar.barTintColor = [UIColor brownColor];
	self.searchController.dimsBackgroundDuringPresentation = NO;
	self.definesPresentationContext = YES;
	self.tableView.tableHeaderView = self.searchController.searchBar;
}

- (IBAction)segmentedControlValueChanged:(id)sender {
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	[self filterEventsForSelectedSegmentTitle:[segmentedControl titleForSegmentAtIndex:segmentedControl.selectedSegmentIndex]];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return filteredEvents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	EventsTableViewCell *cell = (EventsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"eventsCell" forIndexPath:indexPath];
	
	if (cell == nil)
		cell = [[EventsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"eventsCell"];
	
	REVEvent *event = [filteredEvents objectAtIndex:indexPath.row];
	
	cell.textLabel.text = event.name;
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ | %@", event.categoryName, event.venue];
	
	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
}

#pragma mark - Filtering

- (void)filterEventsForSelectedSegmentTitle:(NSString *)segmentTitle {
	filteredEvents = [NSMutableArray arrayWithArray:events];
	[filteredEvents filterUsingPredicate:[NSPredicate predicateWithFormat:@"day == %@", segmentTitle]];
	[self.tableView reloadData];
}

- (void)filterEventsForSearchString:(NSString *)searchString andScopeBarTitle:(NSString *)scopeTitle {
	filteredEvents = [NSMutableArray arrayWithArray:events];
	[filteredEvents filterUsingPredicate:[NSPredicate predicateWithFormat:@"name contains[cd] %@ AND day == %@", searchString, scopeTitle]];
	[self.tableView reloadData];
}

#pragma mark - Search controller results updating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
	UISearchBar *searchBar = searchController.searchBar;
	if (searchBar.text.length > 0) {
		if (searchBar.scopeButtonTitles.count > 0)
			[self filterEventsForSearchString:searchBar.text andScopeBarTitle:searchBar.scopeButtonTitles[searchBar.selectedScopeButtonIndex]];
		else
			[self filterEventsForSearchString:searchBar.text andScopeBarTitle:[self.segmentedControl titleForSegmentAtIndex:self.segmentedControl.selectedSegmentIndex]];
	}
	else {
		[self filterEventsForSelectedSegmentTitle:[self.segmentedControl titleForSegmentAtIndex:self.segmentedControl.selectedSegmentIndex]];
	}
}

#pragma mark - Search bar delegate

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
	if (searchBar.text.length > 0)
		[self filterEventsForSearchString:searchBar.text andScopeBarTitle:searchBar.scopeButtonTitles[searchBar.selectedScopeButtonIndex]];
	else
		[self searchBarCancelButtonClicked:searchBar];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	[self filterEventsForSelectedSegmentTitle:[self.segmentedControl titleForSegmentAtIndex:self.segmentedControl.selectedSegmentIndex]];
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
