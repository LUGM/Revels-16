//
//  EasterEggViewController.m
//  Revels 16
//
//  Created by Avikant Saini on 2/10/16.
//  Copyright © 2016 LUG. All rights reserved.
//

#import "EasterEggViewController.h"
#import "UnderlinedLabel.h"

@interface EasterEggViewController ()

@property (weak, nonatomic) IBOutlet UnderlinedLabel *goBackLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lugImageView;

@property (weak, nonatomic) IBOutlet UILabel *lugLabel;
@property (weak, nonatomic) IBOutlet UILabel *manipalLabel;

@property (weak, nonatomic) IBOutlet UILabel *quoteLabel;

@end

@implementation EasterEggViewController {
	UISwipeGestureRecognizer *swipeGesture;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	if (self.backgroundColor)
		self.view.backgroundColor = self.backgroundColor;
	
	if (self.centerImage)
		self.lugImageView.image = self.centerImage;
	
	if (self.lugText)
		self.lugLabel.text = self.lugText;
	
	if (self.manipalText)
		self.manipalLabel.text = self.manipalText;
	
	if (self.quote)
		self.quoteLabel.text = self.quote;
	
	swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
	swipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
	[self.view addGestureRecognizer:swipeGesture];
	
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
