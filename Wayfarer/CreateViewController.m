//
//  CreateViewController.m
//  Wayfarer
//
//  Created by Chloe on 2016-02-08.
//  Copyright © 2016 Chloe Horgan. All rights reserved.
//

#import "CreateViewController.h"
#import <Photos/Photos.h>
#import <MapKit/MapKit.h>

@interface CreateViewController ()
@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) NSMutableDictionary *locationDictionary;
@property (strong, nonatomic) NSMutableArray *placemarksArray;
@property (strong, nonatomic) PHFetchResult *fetchResult;

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationDictionary = [[NSMutableDictionary alloc] init];
    self.placemarksArray = [[NSMutableArray alloc] init];

    //TESTING RETRIEVING IMAGES
    [self imageRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Helper methods

- (void)imageRequest {
    NSDate *todayStart = [[NSCalendar currentCalendar] startOfDayForDate:[NSDate date]];
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"creationDate >= %@", todayStart];
    self.fetchResult = [PHAsset fetchAssetsWithOptions:fetchOptions];
    PHImageManager *imageManager = [[PHImageManager alloc] init];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsDeliveryModeFastFormat;
    for (PHAsset *asset in self.fetchResult) {
        [imageManager requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                [self geoCoder:asset withImage:imageData];
        }];
    }
}

- (void)geoCoder:(PHAsset *)asset withImage:(NSData *)imageData{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    if (asset.location) {
        CreateViewController * __weak weakSelf = self;
        [geocoder reverseGeocodeLocation:asset.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            // Sorting into locationDictionary
            if (![weakSelf.locationDictionary objectForKey:placemarks[0].subLocality]) {
                [weakSelf.locationDictionary setObject:[[NSMutableArray alloc] init] forKey:placemarks[0].subLocality];
            }
            NSMutableArray *images = [weakSelf.locationDictionary valueForKey:placemarks[0].subLocality];
            [images addObject:[UIImage imageWithData:imageData]];
        }];
    }
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
