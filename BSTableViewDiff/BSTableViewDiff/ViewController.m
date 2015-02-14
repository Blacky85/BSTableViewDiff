//
//  ViewController.m
//  BSTableViewDiff
//
//  Created by Michael Schwarz on 14.02.15.
//  Copyright (c) 2015 Blacksoft. All rights reserved.
//

#import "ViewController.h"
#import "BSTableViewDiff/BSTableViewModel.h"
#import "BSTableViewDiff/UITableView+BSTableViewModelDiffSet.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) BSTableViewModel *tableViewModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableViewModel = [BSTableViewModel tableViewModelWithSectionTitleBlock:^NSString *(id object) {
        return [object valueForKey:@"key"];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSArray *objects = @[@{@"key" : @"section 0",@"hash": @"01"},
                         @{@"key" : @"section 0",@"hash": @"02"},
                         @{@"key" : @"section 0.5",@"hash": @"11"},
                         @{@"key" : @"section 0.5",@"hash": @"12"},
                         @{@"key" : @"section 1",@"hash": @"21"},
                         @{@"key" : @"section 1",@"hash": @"22"},
                         @{@"key" : @"section 2",@"hash": @"31"},
                         @{@"key" : @"section 2",@"hash": @"32"}];
    BSTableViewModelDiffSet *diffset = [self.tableViewModel diffSetForDataArray:objects];
    [self.tableView applyDiffSet:diffset];
}

#pragma mark - uitableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableViewModel.numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableViewModel numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    id obj = [self.tableViewModel objectForIndexPath:indexPath];
    cell.textLabel.text = [obj valueForKey:@"hash"];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.tableViewModel titleForSection:section];
}

@end
