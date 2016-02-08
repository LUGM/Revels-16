//
//  DevelopersViewController.m
//  Revels 16
//
//  Created by Avikant Saini on 2/1/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

#import "DevelopersViewController.h"

@interface DevelopersViewController () <DAHexagonalViewDelegate>

@end

@implementation DevelopersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.hexagonalView = (DAHexagonalView *)self.view;
	self.hexagonalView.delegate = self;

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
	
	if (index == 0 || index == 3)
		NSLog(@"iOS dev pressed");
	
	if (index == 1 || index == 2)
		NSLog(@"Android dev pressed");
	
	if (index == 4)
		NSLog(@"Kartik pressed");
	
	if (index == 5)
		NSLog(@"Sorte pressed");
	
}

- (void)finishedDeveloperAnimations {
	
	printf("\n\n | | | DRAW TEXT | | |\n\n");
	
	CGFloat bottomTextSize = (SWdith > 360)?22.f:18.f;
	
	[self.hexagonalView drawTopText:@"REVELS'16" withAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Futura-Medium" size:50.0]}];
	[self.hexagonalView drawBottomText:@"DAASTAN | Everybody has a Story" withAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Futura-Medium" size:bottomTextSize]}];
	
}

- (void)finishedAllAnimationsDoSomethingAwesome {
	
	printf("\n\n | | | DO AWESOME SHIZZ | | |\n\n");
	// Like make some magic happen
	
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
