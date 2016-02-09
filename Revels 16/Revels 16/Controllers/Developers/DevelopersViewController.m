//
//  DevelopersViewController.m
//  Revels 16
//
//  Created by Avikant Saini on 2/1/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

#import "DevelopersViewController.h"
#import "DeveloperDetailView.h"

@interface DevelopersViewController () <DAHexagonalViewDelegate>

@end

@implementation DevelopersViewController {
	DeveloperDetailView *devDetailView;
	UITapGestureRecognizer *tapGestureRecognizer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
//	self.hexagonalView = (DAHexagonalView *)self.view;
	self.hexagonalView.delegate = self;
	
	tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackground:)];
	
	devDetailView = [[[NSBundle mainBundle] loadNibNamed:@"DeveloperDetailView" owner:nil options:nil] firstObject];

}

- (void)viewDidAppear:(BOOL)animated {
//	[super viewWillAppear:animated];
	[self.hexagonalView animatePath];
}

- (void)viewWillDisappear:(BOOL)animated {
//	[super viewWillDisappear:animated];
	[self.hexagonalView removeAllAnimations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DAHexagonalViewDelegate

- (void)hexagonalViewButtonPressedAtIndex:(NSInteger)index {
	
	// Add a developer detail view
	
	if (index == 10)
		NSLog(@"Revels logo pressed");
	
	if (index == 0) {
		[devDetailView setPersonName:@"Avikant Saini" personDetail:@"iOS Developer\nDu kan om du vil!" personImage:[UIImage imageNamed:@"Avikant"]];
		[devDetailView showInView:self.view animatedFromAnchorPoint:[self.hexagonalView.hexPoints[1] CGPointValue]];
	}
	
	if (index == 3) {
		[devDetailView setPersonName:@"Yash Kumar Lal" personDetail:@"iOS Developer\nIngen kan ta ditt valg!" personImage:[UIImage imageNamed:@"Yash"]];
		[devDetailView showInView:self.view animatedFromAnchorPoint:[self.hexagonalView.hexPoints[5] CGPointValue]];
	}
	
	if (index == 1) {
		[devDetailView setPersonName:@"Anuraag Baishya" personDetail:@"Android Developer\nBare plante tvil!" personImage:[UIImage imageNamed:@"Anuraag"]];
		[devDetailView showInView:self.view animatedFromAnchorPoint:[self.hexagonalView.hexPoints[2] CGPointValue]];
	}
	
	if (index == 2) {
		[devDetailView setPersonName:@"Saketh Kaparthi" personDetail:@"Android Developer\nDet er så mange veier å gå" personImage:[UIImage imageNamed:@"Saketh"]];
		[devDetailView showInView:self.view animatedFromAnchorPoint:[self.hexagonalView.hexPoints[4] CGPointValue]];
	}
	
	if (index == 4) {
		[devDetailView setPersonName:@"Kartik Arora" personDetail:@"Category Head\nMange mål som kan nåes om du våger!" personImage:[UIImage imageNamed:@"Kartik"]];
		[devDetailView showInView:self.view animatedFromAnchorPoint:[self.hexagonalView.hexPoints[0] CGPointValue]];
	}
	
	if (index == 5) {
		[devDetailView setPersonName:@"Shubham Sorte" personDetail:@"Ultimate Bitcher\nÅ tro på at du har det som skal til" personImage:[UIImage imageNamed:@"Sorte"]];
		[devDetailView showInView:self.view animatedFromAnchorPoint:[self.hexagonalView.hexPoints[3] CGPointValue]];
	}
	
	[self.view addGestureRecognizer:tapGestureRecognizer];
	
}

- (void)finishedDeveloperAnimations {
	
	[self.hexagonalView drawTopText:@"REVELS'16" withAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Futura-Medium" size:50.0]}];
	
//	CGFloat bottomTextSize = (SWdith > 360)?22.f:18.f;
//	[self.hexagonalView drawBottomText:@"DAASTAN | Everybody has a Story" withAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Futura-Medium" size:bottomTextSize]}];
	
}

- (void)finishedAllAnimationsDoSomethingAwesome {
//	printf("\n\n | | | DO AWESOME SHIZZ | | |\n\n");
	
}

#pragma mark - Tap gesture handler

- (void)tapBackground:(UITapGestureRecognizer *)recognizer {
	
	[devDetailView dismissFromView:self.view];
	[self.view removeGestureRecognizer:tapGestureRecognizer];
	
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
