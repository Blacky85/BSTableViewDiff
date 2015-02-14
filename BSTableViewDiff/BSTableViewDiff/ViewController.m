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
#import "ExampleModelObject.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) BSTableViewModel *tableViewModel;
@property (weak, nonatomic) IBOutlet UIScrollView *selectionButtonsScrollview;
@property (nonatomic, strong) NSArray *dataSets;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableViewModel = [BSTableViewModel tableViewModelWithSectionTitleBlock:^NSString *(ExampleModelObject *object) {
        return object.section;
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
    ExampleModelObject *obj = [self.tableViewModel objectForIndexPath:indexPath];
    cell.textLabel.text = obj.name;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = obj.color;
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
    NSArray *objects0 = @[[ExampleModelObject modelWithSection:@"section 1" name:@"AAA"],
                          [ExampleModelObject modelWithSection:@"section 2" name:@"BBB"],
                          [ExampleModelObject modelWithSection:@"section 1" name:@"CCC"],
                          [ExampleModelObject modelWithSection:@"section 4" name:@"DDD"],
                          [ExampleModelObject modelWithSection:@"section 1" name:@"EEE"],
                          [ExampleModelObject modelWithSection:@"section 3" name:@"FFF"],
                          [ExampleModelObject modelWithSection:@"section 1" name:@"HHH"],
                          [ExampleModelObject modelWithSection:@"section 1" name:@"JJJ"]];
    
    objects0 = [objects0 sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    
    NSArray *objects1 = @[[ExampleModelObject modelWithSection:@"section 1" name:@"000"],
                          [ExampleModelObject modelWithSection:@"section 1" name:@"AAA"],
                          [ExampleModelObject modelWithSection:@"section 1" name:@"GGG"],
                          [ExampleModelObject modelWithSection:@"section 3" name:@"ZZZ"],
                          [ExampleModelObject modelWithSection:@"section 1" name:@"CCC"],
                          [ExampleModelObject modelWithSection:@"section 4" name:@"DDD"],
                          [ExampleModelObject modelWithSection:@"section 3" name:@"FFF"],
                          [ExampleModelObject modelWithSection:@"section 1" name:@"HHH"],
                          [ExampleModelObject modelWithSection:@"section 1" name:@"JJJ"]];
    
    objects1 = [objects1 sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    
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
