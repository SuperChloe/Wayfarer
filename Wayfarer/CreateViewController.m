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

@interface CreateViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
@property (strong, nonatomic) NSMutableDictionary *locationDictionary;
@property (strong, nonatomic) PHFetchResult *fetchResult;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *photosArray;
@property (strong, nonatomic) NSDate *requestDate;

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //TODAYS DATE
//    self.requestDate = [[NSCalendar currentCalendar] startOfDayForDate:[NSDate date]];
    
    
    //TESTING DATE
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:23];
    [comps setMonth:1];
    [comps setYear:2016];
    NSDate *test = [[NSCalendar currentCalendar] dateFromComponents:comps];
    self.requestDate = [[NSCalendar currentCalendar] startOfDayForDate:test];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

}

- (void)viewWillAppear:(BOOL)animated {
    self.locationDictionary = [[NSMutableDictionary alloc] init];
    self.photosArray = [[NSMutableArray alloc] init];
    [self.locationDictionary removeAllObjects];
    [self.photosArray removeAllObjects];
    [self imageRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Save Button/Realm saving

- (IBAction)saveEntry:(id)sender {
    Entry *newEntry = [[Entry alloc] init];
    newEntry.date = self.requestDate;
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    for (Photo *photo in self.photosArray) {
        photo.entry = newEntry;
        [newEntry.photos addObject:photo];
        [realm addObject:photo];
    }
    [realm addObject:newEntry];
    [realm commitWriteTransaction];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    cell.textView.delegate = self;
    cell.textView.editable = YES;
    NSArray *sortedKeys = [self.locationDictionary.allKeys sortedArrayUsingSelector:@selector(compare:)];
    NSArray *images = [self.locationDictionary objectForKey:sortedKeys[indexPath.row]];
    Photo *photo = images[0];

    cell.photoView.image = [UIImage imageWithData:photo.photo];
    cell.textView.text = photo.location;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(CreateTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - Text View

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return YES;
}

#pragma mark - Retrieving image/location methods

- (void)imageRequest {
    //Fetch todays photos
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"creationDate >= %@", self.requestDate];
    self.fetchResult = [PHAsset fetchAssetsWithOptions:fetchOptions];
    //Get image data
    PHImageManager *imageManager = [[PHImageManager alloc] init];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    for (PHAsset *asset in self.fetchResult) {
        [imageManager requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            //     [self geoCoder:asset withImage:imageData];
            NSArray *inputArray = @[asset, imageData];
            [self performSelector:@selector(geoCoder:) withObject:inputArray afterDelay:1.5];
        }];
    }
}

- (void)geoCoder:(NSArray *)inputArray {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    PHAsset *asset = inputArray[0];
    NSData *imageData = inputArray[1];
    if (asset.location) {
        CreateViewController * __weak weakSelf = self;
        [geocoder reverseGeocodeLocation:asset.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            if (error) {
                NSLog(@"%@", error);
            } else {
                // Sorting into locationDictionary
                if (![weakSelf.locationDictionary objectForKey:placemarks[0].subLocality]) {
                    [weakSelf.locationDictionary setObject:[[NSMutableArray alloc] init] forKey:placemarks[0].subLocality];
                }
                NSMutableArray *images = [weakSelf.locationDictionary valueForKey:placemarks[0].subLocality];
                
                Photo *photo = [[Photo alloc] init];
                photo.location = placemarks[0].subLocality;
                photo.photo = imageData;
                if (images.count == 0) {
                    [self.photosArray addObject:photo];
                }
                [images addObject:photo];
                [self.tableView reloadData];
            }
        }];
    }
}

@end
