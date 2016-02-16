//
//  RegisterWebViewController.m
//  Revels 16
//
//  Created by Avikant Saini on 2/14/16.
//  Copyright © 2016 LUG. All rights reserved.
//

#import "RegisterWebViewController.h"
#import "Reachability.h"
#import "UINavigationItem+Loading.h"

@interface RegisterWebViewController () <WKNavigationDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation RegisterWebViewController

- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	self.webView = [[WKWebView alloc] initWithFrame:CGRectZero];
	
	[self.view insertSubview:self.webView belowSubview:_progressView];
	[self.webView setTranslatesAutoresizingMaskIntoConstraints:NO];
	
	NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.progressView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
	NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-44];
	NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
	[self.view addConstraints:@[top, bottom, width]];
	
	self.webView.navigationDelegate = self;
	
	NSURL *url = [NSURL URLWithString:@"http://register.mitportals.in/"];
	NSString *pageTitle = @"Register for Revels'16";
	
	if ([self.passedTitle length] > 1) {
		pageTitle = self.passedTitle;
		url = self.passedURL;
	}
	
	ASMutableURLRequest *request = [ASMutableURLRequest requestWithURL:url];
	[self.webView loadRequest:request];
	self.navigationItem.title = pageTitle;
	
	[self.navigationItem startAnimatingAt:ANNavBarLoaderPositionRight];
	
	self.backwardBarButton.enabled = NO;
	self.forewardBackButton.enabled = NO;
	
	[self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
	[self.webView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:nil];
	
	Reachability *reachability = [Reachability reachabilityForInternetConnection];
	if (![reachability isReachable]) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			SVHUD_FAILURE(@"No Connection!");
			[self dismissAction:nil];
		});
	}
	
}

- (void)viewDidDisappear:(BOOL)animated {
	[self.webView removeObserver:self forKeyPath:@"estimatedProgress" context:nil];
	[self.webView removeObserver:self forKeyPath:@"loading" context:nil];
}

#pragma mark - Web view navigation delegate

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"estimatedProgress"]) {
		_backwardBarButton.enabled = self.webView.canGoBack;
		_forewardBackButton.enabled = self.webView.canGoForward;
	}
	else if ([keyPath isEqualToString:@"loading"]) {
		_progressView.hidden = (self.webView.estimatedProgress == 1);
		[_progressView setProgress:self.webView.estimatedProgress animated:YES];
	}
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
	[_progressView setProgress:0.0 animated:NO];
	[self.navigationItem stopAnimating];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
	SVHUD_FAILURE(@"Error!");
}

#pragma mark - Tool bar button actions

- (IBAction)goBackAction:(id)sender {
	[self.webView goBack];
}

- (IBAction)goForwardAction:(id)sender {
	[self.webView goForward];
}

- (IBAction)shareAction:(id)sender {
	NSURL *urlToShare = self.webView.URL;
	NSArray *activityItems = @[urlToShare];
	UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
	[self presentViewController:activityVC animated:YES completion:nil];
}

- (IBAction)reloadAction:(id)sender {
	[self.webView reload];
}

- (IBAction)dismissAction:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
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
