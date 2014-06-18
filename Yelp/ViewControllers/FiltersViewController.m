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
#import "OptionCell.h"
#import "YelpCategories.h"

#define CATEOGIES_LIMITS 10
#define BEST_MATCHED @"Best matched"
#define DISTANCE @"Distance"
#define HIGHEST_RATED @"Highest rated"

static NSString * headerCellIdentifier = @"FiltersTableHeaderCell";
static NSString * dropdownCellIdentifier = @"DropdownCell";
static NSString * optionCellIdentifier = @"OptionCell";

static YelpCategories * _categoriesOptions;

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

@property (nonatomic, strong) NSMutableArray * sortByOptions;

@end

@implementation FiltersViewController

+ (void)initialize {
    _categoriesOptions = [[YelpCategories alloc] init];
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
        _sortByExpanded = NO;
        _sortByCollapsing = NO;
        _categoriesExpanded = NO;

        _sortByOptions = [@[BEST_MATCHED, DISTANCE, HIGHEST_RATED] mutableCopy];
    }
    return self;
}

- (void)setFilterOption:(FilterOption *)filterOption {
    NSString * str = _sortByOptions[_filterOption.sort];
    [_sortByOptions removeObjectAtIndex:_filterOption.sort];
    [_sortByOptions insertObject:str atIndex:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView.dataSource = self;
    _tableView.delegate = self;

    UINib *headerCellNib = [UINib nibWithNibName:headerCellIdentifier bundle:nil];
    [_tableView registerNib:headerCellNib forCellReuseIdentifier:headerCellIdentifier];

    UINib *dropdownCellNib = [UINib nibWithNibName:dropdownCellIdentifier bundle:nil];
    [_tableView registerNib:dropdownCellNib forCellReuseIdentifier:dropdownCellIdentifier];

    UINib *optionCellNib = [UINib nibWithNibName:optionCellIdentifier bundle:nil];
    [_tableView registerNib:optionCellNib forCellReuseIdentifier:optionCellIdentifier];
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
    return 30;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == SortBySection) {
        if (_sortByExpanded || _sortByCollapsing) return _sortByOptions.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SortBySection) {
        if (indexPath.row == 0 && !_sortByExpanded) {
            DropdownCell * cell = [_tableView dequeueReusableCellWithIdentifier:dropdownCellIdentifier];
            cell.nameLabel.text = _sortByOptions[0];
            return cell;
        } else {
            OptionCell * cell = [_tableView dequeueReusableCellWithIdentifier:optionCellIdentifier];
            cell.nameLabel.text = _sortByOptions[indexPath.row];
            if (indexPath.row == _filterOption.sort) {
                cell.radioButton.image = [UIImage imageNamed:@"settings-radio-selected"];
            } else {
                cell.radioButton.image = [UIImage imageNamed:@"settings-radio-unselected"];
            }
            return cell;
        }
    }
    if (indexPath.section == RadiusSection) {
    }
    if (indexPath.section == DealsSection) {
        
    }
    if (indexPath.section == CategoriesSection) {
        
    }
    DropdownCell * cell = [_tableView dequeueReusableCellWithIdentifier:dropdownCellIdentifier];
    cell.nameLabel.text = _sortByOptions[0];
    return cell;
    

    //return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SortBySection) {
        if (!_sortByExpanded && indexPath.row == 0) {
            _sortByExpanded = !_sortByExpanded;
            [self expandSortBySection];
        } else if (_sortByExpanded) {
            _sortByExpanded = !_sortByExpanded;
            [self collapseSortBySectionWithRow:indexPath.row];
        }
    }
}

// sort by section helpers

- (void)expandSortBySection {
    NSInteger rows = _sortByOptions.count;
    NSMutableArray * indexPaths = [[NSMutableArray alloc] init];
    for (int i = 1; i < rows; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPaths insertObject:indexPath atIndex:0];
    }
    [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    NSArray * reloadPaths = @[[NSIndexPath indexPathForRow:0 inSection:0]];
    [_tableView reloadRowsAtIndexPaths:reloadPaths withRowAnimation:UITableViewRowAnimationFade];
    

}

- (void)collapseSortBySectionWithRow:(NSInteger)row {
    NSString * str = [_sortByOptions objectAtIndex:row];
    [_sortByOptions removeObjectAtIndex:row];
    [_sortByOptions insertObject:str atIndex:0];
    _filterOption.sort = [self sortModeFromTitle:str];

    _sortByCollapsing = YES;
    NSArray * reloadPaths = @[[NSIndexPath indexPathForRow:row inSection:0]];
    [_tableView reloadRowsAtIndexPaths:reloadPaths withRowAnimation:UITableViewRowAnimationNone];
    _sortByCollapsing = NO;

    NSInteger rows = [_tableView numberOfRowsInSection:0];
    NSMutableArray * indexPaths = [[NSMutableArray alloc] init];
    for (int i = 1; i < rows; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPaths insertObject:indexPath atIndex:0];
    }
    [_tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    
    reloadPaths = @[[NSIndexPath indexPathForRow:0 inSection:0]];
    [_tableView reloadRowsAtIndexPaths:reloadPaths withRowAnimation:UITableViewRowAnimationFade];
    

}


#pragma mark - button handlers

- (void)cancelButtonHandler:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)searchButtonHandler:(id)sender {

    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - helper

- (sortMode)sortModeFromTitle:(NSString *)title {
    if ([title isEqualToString:BEST_MATCHED]) return sortModeBestMatched;
    if ([title isEqualToString:DISTANCE]) return sortModeDistance;
    if ([title isEqualToString:HIGHEST_RATED]) return sortModeHighestRated;
    return -1;
}

@end
