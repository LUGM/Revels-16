//
//  DevelopersViewController.m
//  Revels 16
//
//  Created by Avikant Saini on 2/1/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

#import "DevelopersViewController.h"

@interface DevelopersViewController ()

@end

@implementation DevelopersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[(DAHexagonalView *)self.view animatePath];
	});
	
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
