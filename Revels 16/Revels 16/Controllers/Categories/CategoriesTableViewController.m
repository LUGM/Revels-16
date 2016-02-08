//
//  CategoriesTableViewController.m
//  Revels 16
//
//  Created by Avikant Saini on 2/1/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

#import "CategoriesTableViewController.h"
#import "CategoriesTableViewCell.h"
#import "EventByCategoryViewController.h"
#import <KWTransition/KWTransition.h>
#import <PullToRefreshCoreText/UIScrollView+PullToRefreshCoreText.h>
#import "REVCategory.h"
#import "ShapeWordView.h"

@interface CategoriesTableViewController () <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) KWTransition *transition;
@property (nonatomic, strong) ShapeWordView *shapeWordView;

@end

@implementation CategoriesTableViewController {
	NSMutableArray <REVCategory *> *categories;
	DADataManager *dataManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	dataManager = [DADataManager sharedManager];
	
	categories = [NSMutableArray new];
	
	[self fetchSavedCategories];
	
	// Check for connection
	Reachability *reachability = [Reachability reachabilityForInternetConnection];
	if ([reachability isReachable])
		[self fetchCategories];
	
	self.transition = [KWTransition manager];
	
}

- (void)fetchCategories {
	
	SVHUD_SHOW;
	
    NSURL *categoriesUrl = [NSURL URLWithString:@"http://api.mitportals.in"];
    
    ASMutableURLRequest *postRequest = [ASMutableURLRequest postRequestWithURL:categoriesUrl];
//  NSString *post = [NSString stringWithFormat:@"secret=%@", @"LUGbatchof2017"];
	NSString *post = [NSString stringWithFormat:@"secret=%@&params=%@", @"LUGbatchof2017", @"nid"];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    [postRequest setHTTPBody:postData];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:postRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		
		if (error) {
            SVHUD_FAILURE(@"Failed");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self fetchSavedCategories];
            });
			return;
        }
        
        PRINT_RESPONSE_HEADERS_AND_CODE
		
        id jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//        NSLog(@"%@", jsonData);
		
        if (statusCode == 200)
        {
            id categoryJson = [jsonData valueForKey:@"data"];
            if (categoryJson)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                categories = [REVCategory getArrayFromJSONData:categoryJson];
				[dataManager saveObject:categoryJson toDocumentsFile:@"categories.dat"];
                [self.tableView reloadData];
                });
            }
        }
        else
        {
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
	
	REVCategory *category = [categories objectAtIndex:indexPath.row];
	
	cell.textLabel.text = category.name;
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", category.uid];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	REVCategory *category = [categories objectAtIndex:indexPath.row];
	
	UINavigationController *navC = [self.storyboard instantiateViewControllerWithIdentifier:@"EventsByCVCNav"];
	EventByCategoryViewController *ebcvc = [navC.viewControllers firstObject];
	
//	EventByCategoryViewController *ebcvc = [self.storyboard instantiateViewControllerWithIdentifier:@"EventsByCVC"];
	
	ebcvc.category = category;
	
	self.transition.style = KWTransitionStylePushUp;
	
	[navC setTransitioningDelegate:self];
//	[ebcvc setTransitioningDelegate:self];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	[self.navigationController presentViewController:navC animated:YES completion:nil];
//	[self.navigationController presentViewController:ebcvc animated:YES completion:nil];
//	[self.navigationController pushViewController:ebcvc animated:YES];
	
}

#pragma mark - View controller animated transistioning

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
																   presentingController:(UIViewController *)presenting
																	   sourceController:(UIViewController *)source {
	self.transition.action = KWTransitionStepPresent;
	return self.transition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
	self.transition.action = KWTransitionStepDismiss;
	return self.transition;
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
