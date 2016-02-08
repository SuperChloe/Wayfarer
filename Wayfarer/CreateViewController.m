//
//  CreateViewController.m
//  Wayfarer
//
//  Created by Chloe on 2016-02-08.
//  Copyright © 2016 Chloe Horgan. All rights reserved.
//

#import "CreateViewController.h"
#import <Photos/Photos.h>

@interface CreateViewController ()

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //TESTING RETRIEVING IMAGES
    NSDate *todayStart = [[NSCalendar currentCalendar] startOfDayForDate:[NSDate date]];
    PHFetchOptions *fetchOptions = [PHFetchOptions new];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"creationDate >= %@", todayStart];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithOptions:fetchOptions];
    NSLog(@"%@", todayStart);
    NSLog(@"%@", fetchResult);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
