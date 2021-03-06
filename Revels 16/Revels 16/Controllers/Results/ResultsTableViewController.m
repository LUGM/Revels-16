//
//  ResultsTableViewController.m
//  Revels 16
//
//  Created by Avikant Saini on 2/14/16.
//  Copyright © 2016 LUG. All rights reserved.
//

#import "ResultsTableViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "ResultsHeaderView.h"
#import "REVResult.h"
#import "DADataManager.h"

@interface ResultsTableViewController () <UISearchResultsUpdating, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation ResultsTableViewController {
	
	NSMutableArray *results;
	NSMutableArray *filteredResults;
	
	NSMutableArray *categories;
	
	DADataManager *dataManager;
	
	NSArray <UIColor *> *cellBackgroundColors;
    
    NSString *finalResultUrl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	dataManager = [DADataManager sharedManager];
	
	[self setupSearchController];
	
	results = [NSMutableArray new];
	filteredResults = [NSMutableArray new];
	categories = [NSMutableArray new];
	
	Reachability *reachability = [Reachability reachabilityForInternetConnection];
	if (reachability.isReachable)
		[self fetchResults:nil];
	else {
		[self fetchSavedResults];
		SVHUD_FAILURE(@"No connection!");
	}
	
	cellBackgroundColors = [UIColor revelsColors];
	
	self.selectedIndexPath = nil;
	
	self.tableView.emptyDataSetDelegate = self;
	self.tableView.emptyDataSetSource = self;
	
	self.tableView.tableFooterView = [UIView new];
	
}

- (IBAction)fetchResults:(id)sender {
	
	SVHUD_SHOW;
    
    [PFConfig getConfigInBackgroundWithBlock:^(PFConfig * _Nullable config, NSError * _Nullable error) {
		
        finalResultUrl = config[@"results"];
	
        NSURL *URL = [NSURL URLWithString:finalResultUrl];
	
        ASMutableURLRequest *request = [ASMutableURLRequest requestWithURL:URL];
	
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		
            if (error) {
                // Handle error;
                SVHUD_FAILURE(@"No connection!");
                [self fetchSavedResults];
				[self.refreshControl endRefreshing];
            }
		
            PRINT_RESPONSE_HEADERS_AND_CODE;
		
            if (statusCode == 200) {
			
                @try {
                    id jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                    id resultsJSON = [jsonData valueForKey:@"data"];
                    results = [REVResult getResultsFromJSONData:resultsJSON];
                    [dataManager saveObject:resultsJSON toDocumentsFile:@"results.dat"];
                    categories = [REVResult getCatResultsFromResults:results];
                }
                @catch (NSException *exception) {
                    NSLog(@"Results parsing error: %@", exception.reason);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self fetchSavedResults];
                    });
                }
                @finally {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                        [self.refreshControl endRefreshing];
                    });
                }
            }
		
            SVHUD_HIDE;
		
        }] resume];
        
    }];
	
}

- (void)fetchSavedResults {
	
	if ([dataManager fileExistsInDocuments:@"results.dat"]) {
		
		id jsonData = [dataManager fetchJSONFromDocumentsFileName:@"results.dat"];
		
		if (jsonData != nil) {
			results = [REVResult getResultsFromJSONData:jsonData];
			filteredResults = [NSMutableArray arrayWithArray:results];
			categories = [REVResult getCatResultsFromResults:results];
			[self.tableView reloadData];
		}
	}
}

- (void)setupSearchController {
	self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
	self.searchController.searchResultsUpdater = self;
	self.searchController.searchBar.backgroundColor = [UIColor whiteColor];
	UITextField *txfSearchField = [self.searchController.searchBar valueForKey:@"_searchField"];
	txfSearchField.backgroundColor = [UIColor colorWithWhite:0.90 alpha:1.0];
	self.searchController.searchBar.barTintColor = [UIColor whiteColor];
	self.searchController.searchBar.tintColor = [UIColor blackColor];
	self.searchController.dimsBackgroundDuringPresentation = NO;
	self.definesPresentationContext = YES;
	self.tableView.tableHeaderView = self.searchController.searchBar;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.searchController.isActive)
		return 1;
    return categories.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.searchController.isActive)
		return filteredResults.count;
	return [[categories objectAtIndex:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultsCell" forIndexPath:indexPath];
	
	if (cell == nil)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"resultsCell"];
	
	REVResult *result;
	
	if (self.searchController.isActive)
		result = [filteredResults objectAtIndex:indexPath.row];
	else
		result = [[categories objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	
	cell.textLabel.text = result.eventName;
	
	if ([indexPath compare:self.selectedIndexPath] == NSOrderedSame)
		cell.detailTextLabel.text = result.resultText;
	else
		cell.detailTextLabel.text = @"Show...";
	
	cell.backgroundColor = [cellBackgroundColors objectAtIndex:indexPath.row % cellBackgroundColors.count];
	
    return cell;
}

#pragma mark - Table view delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	ResultsHeaderView *header = [[[NSBundle mainBundle] loadNibNamed:@"ResultsHeaderView" owner:self options:nil] firstObject];
	
	if (header == nil)
		header = [[[NSBundle mainBundle] loadNibNamed:@"ResultsHeaderView" owner:self options:nil] firstObject];
	
	REVResult *result = [[categories objectAtIndex:section] firstObject];
	NSString *catName = result.categoryName;
	
	header.catNameLabel.text = catName;
	header.catImageView.image = [UIImage imageNamed:catName];
	
	return header;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (self.searchController.isActive)
		return 0.f;
	return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([indexPath compare:self.selectedIndexPath] == NSOrderedSame) {
		REVResult *result;
		if (self.searchController.isActive)
			result = [filteredResults objectAtIndex:indexPath.row];
		else
			result = [[categories objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
		if ([result.resultText containsString:@"\n"])
			return 24.f + [[result.resultText componentsSeparatedByString:@"\n"] count] * 20.f;
		return 24.f + [[result.resultText componentsSeparatedByString:@"Team"] count] * 20.f;
	}
	return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView beginUpdates];
	
	if (![indexPath compare:self.selectedIndexPath] == NSOrderedSame)
		self.selectedIndexPath = indexPath;
	else
		self.selectedIndexPath = nil;
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	
	[tableView endUpdates];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[tableView reloadData];
	});

}

#pragma mark - DZN Empty Data Set Source

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
	return [UIImage imageNamed:@"RevelsCutout"];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
	return [UIColor whiteColor];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
	
	NSString *text = @"Results not available right now.";
	
	NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Futura-Medium" size:18.f],
								 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
	
	return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
	
	NSString *text = @"Try again later.";
	
	NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Futura-Medium" size:14.f],
								 NSForegroundColorAttributeName: [UIColor lightGrayColor]};
	
	return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
	
	NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Futura-Medium" size:22.f]};
	
	return [[NSAttributedString alloc] initWithString:@"Reload" attributes:attributes];
}

#pragma mark - DZN Empty Data Set Source

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
	return (results.count == 0);
}

- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView {
	[self fetchResults:nil];
}

#pragma mark - Search controller updater

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
	UISearchBar *searchBar = searchController.searchBar;
	if (searchBar.text.length > 0) {
		[self filterResultsForSearchString:searchBar.text];
	}
	else {
		filteredResults = [NSMutableArray arrayWithArray:results];
		[self.tableView reloadData];
	}
}

- (void)filterResultsForSearchString:(NSString *)searchString {
	filteredResults = [[results filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"eventName contains[cd] %@ OR categoryName contains[cd] %@", searchString, searchString]] mutableCopy];
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
