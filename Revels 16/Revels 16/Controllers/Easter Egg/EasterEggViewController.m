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
	
	NSArray *quotes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	quotes = [NSArray arrayWithObjects:
			  @"Computers are like air conditioners\nthey stop working when you open Windows.",
			  @"Microsoft is not the answer,\nMicrosoft is the question\nNO is the answer.",
			  @"Unix is user friendly.\nIt’s just selective about who its friends are.",
			  @"In a world without fences and walls,\nwho needs Gates and Windows?",
			  @"Avoid the Gates of Hell\nUse Linux.",
			  @"Those who don't understand Linux are doomed to reinvent it, poorly.",
			  @"It's a bird.. It's a plane.. No, it's KernelMan\nFaster than a speeding bullet, to your rescue.\nDoing new kernel versions in under 5 seconds flat!",
			  @"If Bill Gates is the Devil then\nLinus Torvalds must be the Messiah.",
			  @"Linux: the choice of a GNU generation.",
			  @"One OS to rule them all, One OS to find them.\nOne OS to call them all, And in salvation bind them.\nIn the bright land of Linux,\nWhere the hackers play.",
			  @"The Linux philosophy is 'laugh in the face of danger'.\nOops. Wrong one. 'Do it yourself'. That's it.",
			  @"Linux is a cancer that attaches itself in an\nintellectual property sense to everything it touches.",
			  @"My name is Linus, and I am your God.",
			  @"In real open source, you have the right to control your own destiny.",
			  nil];
	
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
	else
		self.quoteLabel.text = [quotes objectAtIndex:arc4random_uniform((int)quotes.count)];
	
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

- (IBAction)githubAction:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/LUGM"]];
}

- (IBAction)facebookAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/LUGManipal/"]];
}

- (IBAction)websiteAction:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.lugmanipal.org"]];
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
