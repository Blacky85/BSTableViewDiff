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
@property (weak, nonatomic) IBOutlet UIScrollView *selectionButtonsScrollview;
@property (nonatomic, strong) NSArray *dataSets;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableViewModel = [BSTableViewModel tableViewModelWithSectionTitleBlock:^NSString *(id object) {
        return [object valueForKey:@"key"];
    }];
    [self setupDataSets];
}

#pragma mark - target/action 

- (void)btnPressed:(UIButton *)btn {
    [self selectDataSet:btn.tag];
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

#pragma mark - private

- (void)selectDataSet:(NSUInteger)dataSetNumber {
    NSArray *dataSet = self.dataSets[dataSetNumber];
    BSTableViewModelDiffSet *diffset = [self.tableViewModel diffSetForDataArray:dataSet];
    [self.tableView applyDiffSet:diffset];
}

- (void)setupDataSets {
    NSArray *objects0 = @[@{@"key" : @"section 0",@"hash": @"01"},
                         @{@"key" : @"section 0",@"hash": @"02"},
                         @{@"key" : @"section 0.5",@"hash": @"11"},
                         @{@"key" : @"section 0.5",@"hash": @"12"},
                         @{@"key" : @"section 1",@"hash": @"21"},
                         @{@"key" : @"section 1",@"hash": @"22"},
                         @{@"key" : @"section 2",@"hash": @"31"},
                         @{@"key" : @"section 2",@"hash": @"32"}];
    
    NSArray *objects1 = @[@{@"key" : @"section 0",@"hash": @"02"},
                         @{@"key" : @"section 0.5",@"hash": @"13"},
                         @{@"key" : @"section 0.5",@"hash": @"12"},
                         @{@"key" : @"section 1",@"hash": @"21"},
                         @{@"key" : @"section 2",@"hash": @"24"},
                         @{@"key" : @"section 2",@"hash": @"31"},
                         @{@"key" : @"section 2",@"hash": @"32"}];
    
    self.dataSets = @[objects0,objects1];
    
    self.selectionButtonsScrollview.pagingEnabled = YES;
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.selectionButtonsScrollview.frame.size.height;
    for (NSUInteger btnNumber = 0; btnNumber < self.dataSets.count; btnNumber++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(width * btnNumber, 0.f, width, height);
        [btn setTitle:[NSString stringWithFormat:@"Dataset Number: %zd",btnNumber]forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = btnNumber;
        [self.selectionButtonsScrollview addSubview:btn];
        [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.selectionButtonsScrollview.contentSize = CGSizeMake((btnNumber + 1) * width, height);
    }
    
    [self selectDataSet:0];
}

@end
