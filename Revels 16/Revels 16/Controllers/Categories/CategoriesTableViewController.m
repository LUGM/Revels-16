//
//  CategoriesTableViewController.m
//  Revels 16
//
//  Created by Avikant Saini on 2/1/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

#import "CategoriesTableViewController.h"
#import "EventByCategoryViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <KWTransition/KWTransition.h>
#import "REVCategory.h"

@interface CategoriesTableViewController () <UIViewControllerTransitioningDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) KWTransition *transition;

@end

@implementation CategoriesTableViewController {
	NSMutableArray <REVCategory *> *categories;
	DADataManager *dataManager;
	
	NSArray <UIColor *> *cellBackgroundColors;
    
    NSString *finalCategoryUrl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	dataManager = [DADataManager sharedManager];
	
	categories = [NSMutableArray new];
	
	[self fetchSavedCategories];
	
	// Check for connection
	Reachability *reachability = [Reachability reachabilityForInternetConnection];
	if ([reachability isReachable])
		[self fetchCategories:nil];
	
	self.transition = [KWTransition manager];
	
	cellBackgroundColors = [UIColor revelsColors];
	
	self.tableView.tableFooterView = [UIView new];
	
	self.tableView.emptyDataSetSource = self;
	self.tableView.emptyDataSetDelegate = self;
	
}

- (IBAction)fetchCategories:(id)sender {
	
	SVHUD_SHOW;
    
    [PFConfig getConfigInBackgroundWithBlock:^(PFConfig * _Nullable config, NSError * _Nullable error) {
        finalCategoryUrl = config[@"categories"];
	
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
                    [self.refreshControl endRefreshing];
                });
                return;
            }
        
                PRINT_RESPONSE_HEADERS_AND_CODE
		
            @try {
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
                            [self.refreshControl endRefreshing];
                        });
                    }
                }
                else
                {
                    SVHUD_FAILURE(@"Failed");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self fetchSavedCategories];
                        [self.refreshControl endRefreshing];
                    });
                }
            }
            @catch (NSException *exception) {
                NSLog(@"Category parsing error: %@", exception.reason);
                SVHUD_FAILURE(@"Failed");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self fetchSavedCategories];
                    [self.refreshControl endRefreshing];
                });
            }
            @finally {
            SVHUD_HIDE;
            }
        
        }] resume];
        
    }];
	
}

- (void)fetchSavedCategories {
	
	if ([dataManager fileExistsInDocuments:@"categories.dat"]) {
		
		@try {
			id jsonData = [dataManager fetchJSONFromDocumentsFileName:@"categories.dat"];
			
			if (jsonData != nil) {
				categories = [REVCategory getArrayFromJSONData:jsonData];
				[self.tableView reloadData];
			}
		}
		@catch (NSException *exception) {
			NSLog(@"Category local parsing error: %@", exception.reason);
		}
		@finally {
			
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
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoriesCell" forIndexPath:indexPath];
	
	if (cell == nil)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"categoriesCell"];
	
	REVCategory *category = [categories objectAtIndex:indexPath.row];
	
	cell.textLabel.text = category.name;
//	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", category.uid];
	
	cell.imageView.image = [UIImage imageNamed:category.imageName];
	
	cell.backgroundColor = [cellBackgroundColors objectAtIndex:indexPath.row % cellBackgroundColors.count];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	REVCategory *category = [categories objectAtIndex:indexPath.row];
	
	UINavigationController *navC = [self.storyboard instantiateViewControllerWithIdentifier:@"EventsByCVCNav"];
	EventByCategoryViewController *ebcvc = [navC.viewControllers firstObject];
	
	ebcvc.category = category;
	
	self.transition.style = KWTransitionStyleUp;

	// No idea why the frak was this animation was causing autolayout problems after dismissing the view.
//	[navC setTransitioningDelegate:self];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	[self.tabBarController presentViewController:navC animated:YES completion:nil];
	
}

#pragma mark - DZN Empty Data Set Source

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
	return [UIImage imageNamed:@"RevelsCutout"];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
	return GLOBAL_BACK_COLOR;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
	
	NSString *text = @"No data found.";
	
	NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Futura-Medium" size:18.f],
								 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
	
	return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
	
	NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Futura-Medium" size:22.f]};
	
	return [[NSAttributedString alloc] initWithString:@"Reload" attributes:attributes];
}

#pragma mark - DZN Empty Set Delegate

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
	return (categories.count == 0);
}

- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView {
	[self fetchCategories:nil];
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
