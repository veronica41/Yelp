//
//  FiltersViewController.m
//  Yelp
//
//  Created by Veronica Zheng on 6/17/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "UIColor+Yelp.h"
#import "FiltersTableHeaderCell.h"
#import "DropdownCell.h"

static NSString * headerCellIdentifier = @"FiltersTableHeaderCell";
static NSString * dropdownCellIdentifier = @"DropdownCell";

typedef enum {
    SortBySection = 0,
    RadiusSection = 1,
    DealsSection = 2,
    CategoriesSection = 3
} filtersTableSection;

@interface FiltersViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) BOOL sortByExpanded;
@property (nonatomic) BOOL radiusExpanded;
@property (nonatomic) BOOL categoriesExpanded;

@property (nonatomic, strong) NSArray * sortByOptions;
@property (nonatomic, strong) NSArray * categoriesOptions;

@end

@implementation FiltersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonHandler:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(searchButtonHandler:)];
        _sortByExpanded = NO;
        _radiusExpanded = NO;
        _categoriesExpanded = NO;

        _sortByOptions = @[@"Best matched", @"Distance", @"Highest rated"];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView.dataSource = self;
    _tableView.delegate = self;

    UINib *headerCellNib = [UINib nibWithNibName:headerCellIdentifier bundle:nil];
    [_tableView registerNib:headerCellNib forCellReuseIdentifier:headerCellIdentifier];

    UINib *dropdownCellNib = [UINib nibWithNibName:dropdownCellIdentifier bundle:nil];
    [_tableView registerNib:dropdownCellNib forCellReuseIdentifier:dropdownCellIdentifier];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section  {
    NSString * title = [self tableView:tableView titleForHeaderInSection:section];
    if(title == nil) return nil;
    FiltersTableHeaderCell * cell = [_tableView dequeueReusableCellWithIdentifier:headerCellIdentifier];
    cell.titleLabel.text = title;
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == SortBySection) return @"Sort";
    if (section == RadiusSection) return @"Radius";
    if (section == DealsSection) return @"Deals";
    if (section == CategoriesSection) return @"Categories";
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DropdownCell * cell = [_tableView dequeueReusableCellWithIdentifier:dropdownCellIdentifier];
    cell.nameLabel.text = @"choice";
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - button handlers

- (void)cancelButtonHandler:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)searchButtonHandler:(id)sender {

    [[self navigationController] popViewControllerAnimated:YES];
}

@end
