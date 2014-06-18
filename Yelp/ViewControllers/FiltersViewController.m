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
#import "YelpCategories.h"
#import "RadiusCell.h"
#import "DealsCell.h"

#define CATEOGIES_LIMITS 10

static NSString * headerCellIdentifier = @"FiltersTableHeaderCell";
static NSString * dropdownCellIdentifier = @"DropdownCell";
static NSString * radiusCellIdentifier = @"RadiusCell";
static NSString * dealsCellIdentifier = @"DealsCell";
static NSString * categoriesCellIdentifier = @"CategoriesCell";

static YelpCategories * _categoriesOptions;
static NSArray * _sortByOptions;

typedef enum {
    SortBySection = 0,
    RadiusSection = 1,
    DealsSection = 2,
    CategoriesSection = 3
} filtersTableSection;

@interface FiltersViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) BOOL sortByExpanded;
@property (nonatomic) BOOL sortByCollapsing;

@property (nonatomic) BOOL categoriesExpanded;
@property (nonatomic, strong) NSMutableArray * selectedCategories;

@end


@implementation FiltersViewController

+ (void)initialize {
    _categoriesOptions = [[YelpCategories alloc] init];
    _sortByOptions = @[BEST_MATCHED, DISTANCE, HIGHEST_RATED];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonHandler:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(searchButtonHandler:)];
        _filterOption = [[FilterOption alloc] init];
 
        _sortByExpanded = NO;
        _sortByExpanded = NO;

        _categoriesExpanded = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    _tableView.allowsMultipleSelectionDuringEditing = YES;

    _tableView.dataSource = self;
    _tableView.delegate = self;

    UINib *headerCellNib = [UINib nibWithNibName:headerCellIdentifier bundle:nil];
    [_tableView registerNib:headerCellNib forCellReuseIdentifier:headerCellIdentifier];

    UINib *dropdownCellNib = [UINib nibWithNibName:dropdownCellIdentifier bundle:nil];
    [_tableView registerNib:dropdownCellNib forCellReuseIdentifier:dropdownCellIdentifier];

    UINib *radiusCellNib = [UINib nibWithNibName:radiusCellIdentifier bundle:nil];
    [_tableView registerNib:radiusCellNib forCellReuseIdentifier:radiusCellIdentifier];

    UINib *dealsCellNib = [UINib nibWithNibName:dealsCellIdentifier bundle:nil];
    [_tableView registerNib:dealsCellNib forCellReuseIdentifier:dealsCellIdentifier];

    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:categoriesCellIdentifier];
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

    // a wrapper to solve header disappear and warning problem
    UIView * headerView = [[UIView alloc] initWithFrame:[cell frame]];
    [headerView addSubview:cell];
    return headerView;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == SortBySection) return @"Sort";
    if (section == RadiusSection) return @"Radius";
    if (section == DealsSection) return @"Deals";
    if (section == CategoriesSection) return @"Categories";
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == SortBySection) {
        if (_sortByExpanded || _sortByCollapsing) return _sortByOptions.count;
    }
    if (section == CategoriesSection) {
        if (!_categoriesExpanded) {
            return 5;
        }
        return _categoriesOptions.categoriesDict.allKeys.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == CategoriesSection) return 39;
    return 39;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SortBySection) {
        DropdownCell * cell = [_tableView dequeueReusableCellWithIdentifier:dropdownCellIdentifier];
        if (indexPath.row == 0 && !_sortByExpanded) {
            cell.nameLabel.text = _sortByOptions[_filterOption.sortFilter];
            cell.dropDownButton.image = [UIImage imageNamed:@"arrow_collapse"];
        } else {
            cell.nameLabel.text = _sortByOptions[indexPath.row];
            if (_filterOption.sortFilter == indexPath.row) {
                cell.dropDownButton.image = [UIImage imageNamed:@"settings-radio-selected"];
            } else {
                cell.dropDownButton.image = [UIImage imageNamed:@"settings-radio-unselected"];
            }
        }
        return cell;
    }
    if (indexPath.section == RadiusSection) {
        RadiusCell * cell = [_tableView dequeueReusableCellWithIdentifier:radiusCellIdentifier];
        return cell;
    }
    if (indexPath.section == DealsSection) {
        DealsCell * cell = [_tableView dequeueReusableCellWithIdentifier:dealsCellIdentifier];
        cell.dealsLabel.text = @"Offering a deal";
        cell.dealsSwitch.on = _filterOption.dealsFilter;
        [cell.dealsSwitch addTarget:self action:@selector(dealSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
        return cell;
    }
    
    if (indexPath.section == CategoriesSection) {
        UITableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:categoriesCellIdentifier];
        [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        if (!_categoriesExpanded && indexPath.row == 4) {
            cell.textLabel.text = @"See All";
            [cell.textLabel setTextColor:[UIColor yelpRedColor]];
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        } else {
            cell.textLabel.text = _categoriesOptions.categoriesDict.allKeys[indexPath.row];
            [cell.textLabel setTextColor:[UIColor blackColor]];
            [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
        }
        if ([_filterOption.categories containsObject:[NSNumber numberWithInteger:indexPath.row]]) {
            [cell setSelected:YES];
        }
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SortBySection) {
        if (!_sortByExpanded) {
            [self expandSortBySection];
        } else if (_sortByExpanded) {
            [self collapseSortBySectionWithRow:indexPath.row];
        }
    } else if (indexPath.section == CategoriesSection) {
        if (!_categoriesExpanded && indexPath.row == 4) {
            _categoriesExpanded = YES;
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:CategoriesSection] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [_filterOption.categories insertObject:[NSNumber numberWithInteger:indexPath.row] atIndex:0];
        }
    }
}

// sort by section helpers

- (void)expandSortBySection {
    _sortByExpanded = YES;

    NSInteger rows = _sortByOptions.count;
    NSMutableArray * indexPaths = [[NSMutableArray alloc] init];
    for (int i = 1; i < rows; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPaths insertObject:indexPath atIndex:0];
    }
    [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    NSArray * reloadPaths = @[[NSIndexPath indexPathForRow:0 inSection:0]];
    [_tableView reloadRowsAtIndexPaths:reloadPaths withRowAnimation:UITableViewRowAnimationBottom];
}

- (void)collapseSortBySectionWithRow:(NSInteger)row {
    int oldSelection = _filterOption.sortFilter;
    _filterOption.sortFilter = (sortMode)row;
    // change radio button selection
    NSArray * reloadPaths = @[[NSIndexPath indexPathForRow:row inSection:0]];
    [_tableView reloadRowsAtIndexPaths:reloadPaths withRowAnimation:UITableViewRowAnimationNone];
    reloadPaths = @[[NSIndexPath indexPathForRow:oldSelection inSection:0]];
    [_tableView reloadRowsAtIndexPaths:reloadPaths withRowAnimation:UITableViewRowAnimationNone];

    _sortByExpanded = NO;
    // introduce delay
    [self performSelector:@selector(removeRows) withObject:self afterDelay:0.5 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
}

// helper for collapse
- (void)removeRows {
    _sortByCollapsing = YES;
    NSArray * reloadPaths = @[[NSIndexPath indexPathForRow:0 inSection:0]];
    [_tableView reloadRowsAtIndexPaths:reloadPaths withRowAnimation:UITableViewRowAnimationNone];
    _sortByCollapsing = NO;

    NSInteger rows = [_tableView numberOfRowsInSection:0];
    NSMutableArray * indexPaths = [[NSMutableArray alloc] init];
    for (int i = 1; i < rows; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPaths insertObject:indexPath atIndex:0];
    }
    [_tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
}


#pragma mark - button handlers

- (void)cancelButtonHandler:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)searchButtonHandler:(id)sender {
    [self.delegate searchWithFilterOption:_filterOption];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)dealSwitchValueChanged:(id)sender {
    _filterOption.dealsFilter = ((UISwitch *)sender).on;
}

@end
