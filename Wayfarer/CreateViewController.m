//
//  CreateViewController.m
//  Wayfarer
//
//  Created by Chloe on 2016-02-08.
//  Copyright © 2016 Chloe Horgan. All rights reserved.
//

#import <Photos/Photos.h>
#import <MapKit/MapKit.h>
#import "CreateViewController.h"
#import "CreateTableViewCell.h"
#import "Photo.h"
#import "Entry.h"

@interface CreateViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableDictionary *locationDictionary;
@property (strong, nonatomic) PHFetchResult *fetchResult;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *photosArray;

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.locationDictionary = [[NSMutableDictionary alloc] init];
    self.photosArray = [[NSMutableArray alloc] init];
    [self imageRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Save Button/Realm saving

- (IBAction)saveEntry:(id)sender {
    Entry *newEntry = [[Entry alloc] init];
    NSDate *todayStart = [[NSCalendar currentCalendar] startOfDayForDate:[NSDate date]];
    newEntry.date = todayStart;
    for (Photo *photo in self.photosArray) {
        photo.entry = newEntry;
    }
}


#pragma mark - Table View methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locationDictionary.allKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CreateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateCell" forIndexPath:indexPath];
    [self configureCell:cell forIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(CreateTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    NSArray *sortedKeys = [self.locationDictionary.allKeys sortedArrayUsingSelector:@selector(compare:)];
    NSArray *images = [self.locationDictionary objectForKey:sortedKeys[indexPath.row]];
    Photo *photo = [[Photo alloc] init];
    photo.photo = images[arc4random()%images.count];
    photo.location = sortedKeys[indexPath.row];
    [self.photosArray addObject:photo];
    cell.photoView.image = [UIImage imageWithData:photo.photo];
    cell.textView.text = photo.location;
}

#pragma mark - Retrieving image/location methods

- (void)imageRequest {
    //Fetch todays photos
    NSDate *todayStart = [[NSCalendar currentCalendar] startOfDayForDate:[NSDate date]];
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"creationDate >= %@", todayStart];
    self.fetchResult = [PHAsset fetchAssetsWithOptions:fetchOptions];
    //Get image data
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
            [images addObject:imageData];
            [self.tableView reloadData];
        }];
    }
}


@end
