//
//  FiltersViewController.m
//  Yelp
//
//  Created by Veronica Zheng on 6/17/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "UIColor+Yelp.h"
#import "YelpCategories.h"
#import "RadiusCell.h"

#define INIT_CATEGORIES_TO_SHOW 4

static NSString * filtersCellIdentifier = @"FiltersCell";
static NSString * radiusCellIdentifier = @"RadiusCell";

static NSArray * _categoriesOptions;
static NSDictionary * _categoriesDict;
static NSArray * _sortByOptions;

typedef enum {
    SortBySection = 0,
    RadiusSection = 1,
    DealsSection = 2,
    CategoriesSection = 3
} filtersTableSection;

@interface FiltersViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISwitch *dealsSwitch;

@property (nonatomic) BOOL sortByExpanded;
@property (nonatomic) BOOL categoriesExpanded;

@end


@implementation FiltersViewController

+ (void)initialize {
    _categoriesOptions = [YelpCategories categories];
    _categoriesDict = [YelpCategories categoriesDict];
    _sortByOptions = @[BEST_MATCHED, DISTANCE, HIGHEST_RATED];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _filterOption = [[FilterOption alloc] init];
        _sortByExpanded = NO;
        _categoriesExpanded = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // setup navigation bar
    self.title = @"Filters";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(cancelButtonHandler:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(searchButtonHandler:)];

    // setup switch
    _dealsSwitch = [[UISwitch alloc] init];
    [_dealsSwitch addTarget:self
                     action:@selector(dealSwitchValueChanged:)
           forControlEvents:UIControlEventValueChanged];
    _dealsSwitch.on = _filterOption.dealsFilter;

    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setRowHeight:39];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:filtersCellIdentifier];

    UINib *tableCellNib = [UINib nibWithNibName:radiusCellIdentifier bundle:nil];
    [_tableView registerNib:tableCellNib forCellReuseIdentifier:radiusCellIdentifier];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case SortBySection:
            return @"Sort";
        case RadiusSection:
            return @"Radius";
        case DealsSection:
            return @"Deals";
        case CategoriesSection:
            return @"Categories";
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    // I don't like all UpperCase string
    UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
    tableViewHeaderFooterView.textLabel.text = [tableViewHeaderFooterView.textLabel.text capitalizedString];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case SortBySection:
            if (_sortByExpanded) return _sortByOptions.count;
            return 1;
        case CategoriesSection:
            if (!_categoriesExpanded) {
                return INIT_CATEGORIES_TO_SHOW+1;
            } else {
                return _categoriesOptions.count;
            }
        case DealsSection:
        case RadiusSection:
            return 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    switch (section) {
        case SortBySection:
        {
            UITableViewCell * cell = [self standardCell];
            UIImageView * accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 21, 21)];
            if (!_sortByExpanded) {
                NSAssert(row == 0, @"only 1 row when collapsed");
                cell.textLabel.text = _sortByOptions[_filterOption.sortFilter];
                accessoryView.image = [UIImage imageNamed:@"arrow_collapse"];
            } else {
                cell.textLabel.text = _sortByOptions[row];
                if (_filterOption.sortFilter == row) {
                   accessoryView.image = [UIImage imageNamed:@"settings-radio-selected"];
                } else {
                   accessoryView.image = [UIImage imageNamed:@"settings-radio-unselected"];
                }
            }
            cell.accessoryView = accessoryView;
            return cell;
        }
        case RadiusSection:
        {
            RadiusCell * radiusCell = [_tableView dequeueReusableCellWithIdentifier:radiusCellIdentifier];
            radiusCell.radius = _filterOption.radiusFilter;
            return radiusCell;
        }
        case DealsSection:
        {
            UITableViewCell * cell = [self standardCell];
            cell.textLabel.text = @"Offering a deal";
            _dealsSwitch.on = _filterOption.dealsFilter;
            cell.accessoryView = _dealsSwitch;
            return cell;
        }
        case CategoriesSection:
        {
            UITableViewCell * cell = [self standardCell];
            if (!_categoriesExpanded && row == INIT_CATEGORIES_TO_SHOW) {
                cell.textLabel.text = @"See All";
                [cell.textLabel setTextColor:[UIColor yelpRedColor]];
                [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
            } else {
                cell.textLabel.text = _categoriesOptions[row];
            }
            return cell;
        }
    }
    return nil;
}

// helper
- (UITableViewCell *)standardCell {
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:filtersCellIdentifier];
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [cell.textLabel setTextColor:[UIColor blackColor]];
    [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
    cell.accessoryView = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    switch (section) {
        case SortBySection:
            if (!_sortByExpanded) {
                [self expandSortBySection];
            } else {
                [self collapseSortBySectionWithRow:row];
            }
            break;
        case CategoriesSection:
            if (!_categoriesExpanded && indexPath.row == INIT_CATEGORIES_TO_SHOW) {
                _categoriesExpanded = YES;
               [_tableView reloadSections:[NSIndexSet indexSetWithIndex:CategoriesSection] withRowAnimation:UITableViewRowAnimationFade];
            } else {
               [self toggleCategorySelectionAtRow:row];
            }
            break;
        case DealsSection:
        case RadiusSection:
            break;
    }
}

// sort by section helpers

- (void)expandSortBySection {
    _sortByExpanded = YES;
    [self reloadSortBySection];
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
    [self performSelector:@selector(reloadSortBySection) withObject:self afterDelay:0.5 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
}

// helper
- (void)reloadSortBySection {
   [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:SortBySection] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)toggleCategorySelectionAtRow:(NSInteger)row {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:CategoriesSection];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    NSString * category = [NSString stringWithFormat:@"%ld", (long)row];
    if ([_filterOption.categories containsObject:category]) {
        [_filterOption.categories removeObject:category];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        [_filterOption.categories addObject:category];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

#pragma mark - RadiusCellDelegate

- (void)sliderValueChanged:(int)value {
    _filterOption.radiusFilter = value;
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
