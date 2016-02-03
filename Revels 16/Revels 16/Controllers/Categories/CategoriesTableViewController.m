//
//  CategoriesTableViewController.m
//  Revels 16
//
//  Created by Avikant Saini on 2/1/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

#import "CategoriesTableViewController.h"
#import "CategoriesTableViewCell.h"
#import "REVCategory.h"

@interface CategoriesTableViewController () <UISearchResultsUpdating>

@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation CategoriesTableViewController {
	NSMutableArray <REVCategory *> *categories;
	NSMutableArray <REVCategory *> *filteredCategories;
	DADataManager *dataManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	dataManager = [DADataManager sharedManager];
	
	categories = [NSMutableArray new];
	filteredCategories = [NSMutableArray new];
	
	[self fetchSavedCategories];
	
	// Check for connection
//	[self fetchCategories];
	
	[self setupSearchController];
	
}

- (void)fetchCategories {
	
	SVHUD_SHOW;
	
	NSURL *URL = [NSURL URLWithString:@"http://api.techtatva.in/categories"];
	
	ASMutableURLRequest *request = [ASMutableURLRequest getRequestWithURL:URL];
	
	[[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		
		if (error) {
			SVHUD_FAILURE(@"Failed");
			dispatch_async(dispatch_get_main_queue(), ^{
				[self fetchSavedCategories];
            });
		}
		
		PRINT_RESPONSE_HEADERS_AND_CODE;
		
		id jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
		
		if (statusCode == 200) {
			
			id catJSON = [jsonData valueForKey:@"data"];
			if (catJSON) {
				dispatch_async(dispatch_get_main_queue(), ^{
					categories = [REVCategory getArrayFromJSONData:catJSON];
					filteredCategories  = [NSMutableArray arrayWithArray:categories];
					[dataManager saveObject:catJSON toDocumentsFile:@"categories.dat"];
					[self.tableView reloadData];
				});
			}
		}
		else {
			
			SVHUD_FAILURE(@"Failed");
			dispatch_async(dispatch_get_main_queue(), ^{
				[self fetchSavedCategories];
			});
		}
		
		SVHUD_HIDE;
		
	}] resume];
	
}

- (void)fetchSavedCategories {
	
	if ([dataManager fileExistsInDocuments:@"categories.dat"]) {
		
		id jsonData = [dataManager fetchJSONFromDocumentsFileName:@"categories.dat"];
		
		if (jsonData != nil) {
			categories = [REVCategory getArrayFromJSONData:jsonData];
			filteredCategories = [NSMutableArray arrayWithArray:categories];
			[self.tableView reloadData];
		}
	}
	
}

- (void)setupSearchController {
	self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
	self.searchController.searchResultsUpdater = self;
	self.searchController.hidesNavigationBarDuringPresentation = NO;
	self.searchController.dimsBackgroundDuringPresentation = NO;
	self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
	self.definesPresentationContext = YES;
	self.tableView.tableHeaderView = self.searchController.searchBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.searchController.isActive && self.searchController.searchBar.text.length > 0)
		return filteredCategories.count;
    return categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	CategoriesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoriesCell" forIndexPath:indexPath];
	
	if (cell == nil)
		cell = [[CategoriesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"categoriesCell"];
	
	REVCategory *category;
	if (self.searchController.isActive && self.searchController.searchBar.text.length > 0)
		category = [filteredCategories objectAtIndex:indexPath.row];
	else
		category = [categories objectAtIndex:indexPath.row];
	
	cell.textLabel.text = category.name;
	cell.detailTextLabel.text = category.type;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
}

#pragma mark - Search controller results updating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
	filteredCategories = [[categories filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name contains [cd] %@", searchController.searchBar.text]] mutableCopy];
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
