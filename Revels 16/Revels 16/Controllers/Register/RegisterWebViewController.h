//
//  RegisterWebViewController.h
//  Revels 16
//
//  Created by Avikant Saini on 2/14/16.
//  Copyright © 2016 LUG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface RegisterWebViewController : UIViewController

@property (nonatomic, strong) NSURL *passedURL;
@property (nonatomic, strong) NSString *passedTitle;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backwardBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forewardBackButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *reloadBarButton;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;


@end
