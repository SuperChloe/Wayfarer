//
//  DetailViewController.m
//  Wayfarer
//
//  Created by Chloe on 2016-02-08.
//  Copyright © 2016 Chloe Horgan. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailTableViewCell.h"
#import "Photo.h"
#import "ParallaxHeaderView.h"

@interface DetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) ParallaxHeaderView *headerView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    //Parallax header
    Photo *headerPhoto = self.entry.photos[arc4random()%self.entry.photos.count];
    self.headerView = [ParallaxHeaderView parallaxHeaderViewWithImage:[UIImage imageWithData:headerPhoto.photo] forSize:CGSizeMake(self.tableView.frame.size.width, 150)];
    NSMutableAttributedString *kerning = [[NSMutableAttributedString alloc] initWithString:([[NSDateFormatter localizedStringFromDate:self.entry.date dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterNoStyle] uppercaseString])];
    [kerning addAttribute:NSKernAttributeName
                    value:@4
                    range:NSMakeRange(0, [kerning length])];
    self.headerView.headerTitleLabel.frame = CGRectMake(0, 0, 325, 35);
    self.headerView.headerTitleLabel.attributedText = kerning;
    self.headerView.headerTitleLabel.backgroundColor = [UIColor whiteColor];
    self.headerView.headerTitleLabel.alpha = 0.75;
    self.headerView.imageView.alpha = 0.5;
    [self.tableView setTableHeaderView:self.headerView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.headerView.headerTitleLabel.center = CGPointMake(self.headerView.center.x, (self.headerView.center.y + self.topLayoutGuide.length));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View methods

//For parallax header
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        [(ParallaxHeaderView *)self.tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.entry.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
    [self configureCell:cell forIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(DetailTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    Photo *photo = self.entry.photos[indexPath.row];
    cell.photoView.image = [UIImage imageWithData:photo.photo];
    cell.captionLabel.text = photo.location;
}

@end
