//
//  ViewController.m
//  Wayfarer
//
//  Created by Chloe on 2016-02-08.
//  Copyright © 2016 Chloe Horgan. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "EntryTableViewCell.h"
#import "Entry.h"
#import <Photos/Photos.h>

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) RLMResults *sortedEntries;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    self.sortedEntries = [[Entry allObjects] sortedResultsUsingProperty:@"date" ascending:NO];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"entryDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Entry *entry = self.sortedEntries[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[segue destinationViewController];
        controller.entry = entry;
    }
}


#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sortedEntries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Entry *entry = self.sortedEntries[indexPath.row];
    EntryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EntryCell" forIndexPath:indexPath];
    NSMutableAttributedString *kerning = [[NSMutableAttributedString alloc] initWithString:([[NSDateFormatter localizedStringFromDate:entry.date dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterNoStyle] uppercaseString])];
    [kerning addAttribute:NSKernAttributeName
                        value:@4
                        range:NSMakeRange(0, [kerning length])];
    cell.dateLabel.attributedText = kerning;
    cell.entryPreview.clipsToBounds = YES;
    cell.entryPreview.image = [UIImage imageWithData:entry.photos[0].photo];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Entry *entry = self.sortedEntries[indexPath.row];
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        for (Photo *photo in entry.photos) {
            [realm deleteObject:photo];
        }
        [realm deleteObject:entry];
        [realm commitWriteTransaction];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
