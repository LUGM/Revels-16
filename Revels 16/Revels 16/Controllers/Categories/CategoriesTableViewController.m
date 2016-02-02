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

@interface CategoriesTableViewController ()

@end

@implementation CategoriesTableViewController {
	NSMutableArray *categories;
	DADataManager *dataManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	dataManager = [DADataManager sharedManager];
	
	categories = [NSMutableArray new];
	
	[self fetchSavedCategories];
	
	[self fetchCategories];
	
}

- (void)fetchCategories {
	
	SVHUD_SHOW;
	
	NSURL *URL = [NSURL URLWithString:@"http://api.techtatva.in/categories"];
	
	ASMutableURLRequest *request = [ASMutableURLRequest getRequestWithURL:URL];
	
	[[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		
		if (error) {
			SVHUD_FAILURE(@"Failed");
			dispatch_async(dispatch_get_main_queue(), ^{
				
			});
		}
		
		PRINT_RESPONSE_HEADERS_AND_CODE;
		
		if (statusCode == 200) {
			
		}
		
		SVHUD_HIDE;
		
	}] resume];
	
}

- (void)fetchSavedCategories {
	
	if ([dataManager fileExistsInDocuments:@"categories.dat"]) {
		
		id jsonData = [dataManager fetchJSONFromDocumentsFileName:@"categories.dat"];
		
		if (jsonData != nil) {
			categories = [REVCategory getArrayFromJSONData:jsonData];
			[self.tableView reloadData];
		}
	}
	
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
    return categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	CategoriesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoriesCell" forIndexPath:indexPath];
	
	if (cell == nil)
		cell = [[CategoriesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"categoriesCell"];
	
	cell.textLabel.text = categories[indexPath.row];
	cell.detailTextLabel.text = categories[3 - indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
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
