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

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //TESTING RETRIEVING IMAGES
    NSDate *todayStart = [[NSCalendar currentCalendar] startOfDayForDate:[NSDate date]];
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"creationDate >= %@", todayStart];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithOptions:fetchOptions];
    NSLog(@"%@", todayStart);
    NSLog(@"%@", fetchResult);
    
    PHImageManager *imageManager = [[PHImageManager alloc] init];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsDeliveryModeFastFormat;
    for (PHAsset *asset in fetchResult) {
        [imageManager requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
            imageView.image = image;
            [self.view addSubview:imageView];
        }];
        if (asset.location) {
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            [geocoder reverseGeocodeLocation:asset.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                CLPlacemark *placemark = placemarks[0];
                NSLog(@"%@", asset.location);
                NSLog(@"%@", placemark.subLocality);
            }];
        } else {
            
            NSLog(@"No geotag");
        }
    }
    
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
