//
//  BSTableViewDiffTests.m
//  BSTableViewDiffTests
//
//  Created by Michael Schwarz on 14.02.15.
//  Copyright (c) 2015 Blacksoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "BSTableViewModel.h"
#import "BSTableViewModelDiffSet.h"

@interface BSTableViewDiffTests : XCTestCase

@end

@implementation BSTableViewDiffTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testInsertionOfRows {
    NSArray *objects = @[@1,@2,@3,@4];
    
    BSTableViewModel *tableViewModel = [BSTableViewModel new];
    BSTableViewModelDiffSet *diffSet =  [tableViewModel diffSetForDataArray:objects withSectionKey:nil];
    XCTAssert(diffSet.rowsToInsert.count == 4);
    XCTAssert(diffSet.rowsToDelete.count == 0);
    XCTAssert(diffSet.sectionsToInsert.count == 1);
    XCTAssert(diffSet.sectionsToDelete.count == 0);
    
    for (NSUInteger i = 0; i < objects.count; i++) {
        NSIndexPath *indexPathRow0 = diffSet.rowsToInsert[i];
        XCTAssert(indexPathRow0.row == i);
        XCTAssert(indexPathRow0.section == 0);
    }
    
    //Test insertion of new row on position 1
    objects = @[@1,@5,@2,@3,@4];
    diffSet =  [tableViewModel diffSetForDataArray:objects withSectionKey:nil];
    XCTAssert(diffSet.rowsToInsert.count == 1);
    XCTAssert(diffSet.rowsToDelete.count == 0);
    XCTAssert(diffSet.sectionsToInsert.count == 0);
    XCTAssert(diffSet.sectionsToDelete.count == 0);
    NSIndexPath *indexPath = diffSet.rowsToInsert[0];
    XCTAssert(indexPath.row == 1);
    XCTAssert(indexPath.section == 0);
}

- (void)testInsertionOfSections {
    NSArray *objects = @[@{@"key" : @"section 0"},
                         @{@"key" : @"section 0"},
                         @{@"key" : @"section 1"},
                         @{@"key" : @"section 1"},
                         @{@"key" : @"section 2"},
                         @{@"key" : @"section 2"}];
    
    BSTableViewModel *tableViewModel = [BSTableViewModel new];
    BSTableViewModelDiffSet *diffSet =  [tableViewModel diffSetForDataArray:objects withSectionKey:@"key"];
    XCTAssert(diffSet.rowsToInsert.count == 6);
    XCTAssert(diffSet.sectionsToInsert.count == 3);
    
    __block NSUInteger section = 0;
    [diffSet.sectionsToInsert enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        XCTAssert(idx == section);
        section++;
    }];
    
    objects = @[@{@"key" : @"section 0"},
                @{@"key" : @"section 0"},
                @{@"key" : @"section 0.5"},
                @{@"key" : @"section 0.5"},
                @{@"key" : @"section 1"},
                @{@"key" : @"section 1"},
                @{@"key" : @"section 2"},
                @{@"key" : @"section 2"}];
    
    diffSet =  [tableViewModel diffSetForDataArray:objects withSectionKey:@"key"];
    XCTAssert(diffSet.rowsToInsert.count == 2);
    XCTAssert(diffSet.sectionsToInsert.count == 1);
    XCTAssert(diffSet.sectionsToDelete.count == 0);
    XCTAssert(diffSet.rowsToDelete.count == 0);
    XCTAssert(diffSet.sectionsToInsert.firstIndex == 1);
}

- (void)testDeletionOfRows {
    NSArray *objects = @[@1,@2,@3,@4];
    
    BSTableViewModel *tableViewModel = [BSTableViewModel new];
    BSTableViewModelDiffSet *diffSet =  [tableViewModel diffSetForDataArray:objects withSectionKey:nil];
    objects = @[@1,@2,@4];
    diffSet =  [tableViewModel diffSetForDataArray:objects withSectionKey:nil];
    XCTAssert(diffSet.rowsToInsert.count == 0);
    XCTAssert(diffSet.rowsToDelete.count == 1);
    XCTAssert(diffSet.sectionsToDelete.count == 0);
    XCTAssert(diffSet.sectionsToInsert.count == 0);
    NSIndexPath *indexPath = diffSet.rowsToDelete[0];
    XCTAssert(indexPath.row == 2);
    XCTAssert(indexPath.section == 0);
}

- (void)testDeletionOfSections {
    NSArray *objects = @[@{@"key" : @"section 0"},
                         @{@"key" : @"section 0"},
                         @{@"key" : @"section 0.5"},
                         @{@"key" : @"section 0.5"},
                         @{@"key" : @"section 1"},
                         @{@"key" : @"section 1"},
                         @{@"key" : @"section 2"},
                         @{@"key" : @"section 2"}];
    
    BSTableViewModel *tableViewModel = [BSTableViewModel new];
    BSTableViewModelDiffSet *diffSet =  [tableViewModel diffSetForDataArray:objects withSectionKey:@"key"];
    
    objects = @[@{@"key" : @"section 0"},
                @{@"key" : @"section 0"},
                @{@"key" : @"section 1"},
                @{@"key" : @"section 1"},
                @{@"key" : @"section 2"},
                @{@"key" : @"section 2"}];
    
    diffSet =  [tableViewModel diffSetForDataArray:objects withSectionKey:@"key"];
    XCTAssert(diffSet.rowsToInsert.count == 0);
    XCTAssert(diffSet.sectionsToInsert.count == 0);
    XCTAssert(diffSet.rowsToDelete.count == 0);
    XCTAssert(diffSet.sectionsToDelete.count == 1);
    
    XCTAssert(diffSet.sectionsToDelete.firstIndex == 1);
}

- (void)testInsertionAndDeletionMixInSingleSection {
    NSArray *objects = @[@1,@2,@3,@4];
    
    BSTableViewModel *tableViewModel = [BSTableViewModel new];
    BSTableViewModelDiffSet *diffSet =  [tableViewModel diffSetForDataArray:objects withSectionKey:nil];
    
    objects = @[@1,@5,@6,@3,@4];
    diffSet =  [tableViewModel diffSetForDataArray:objects withSectionKey:nil];
    XCTAssert(diffSet.rowsToInsert.count == 2);
    XCTAssert(diffSet.rowsToDelete.count == 1);
    XCTAssert(diffSet.sectionsToInsert.count == 0);
    XCTAssert(diffSet.sectionsToDelete.count == 0);
    NSIndexPath *indexPath = diffSet.rowsToInsert[0];
    XCTAssert(indexPath.row == 1);
    XCTAssert(indexPath.section == 0);
    indexPath = diffSet.rowsToInsert[1];
    XCTAssert(indexPath.row == 2);
    XCTAssert(indexPath.section == 0);
    indexPath = diffSet.rowsToDelete[0];
    XCTAssert(indexPath.row == 1);
    XCTAssert(indexPath.section == 0);
    
    objects = @[@42,@1,@5,@6,@3,@9,@18];
    diffSet =  [tableViewModel diffSetForDataArray:objects withSectionKey:nil];
    XCTAssert(diffSet.rowsToInsert.count == 3);
    XCTAssert(diffSet.rowsToDelete.count == 1);
    XCTAssert(diffSet.sectionsToInsert.count == 0);
    XCTAssert(diffSet.sectionsToDelete.count == 0);
    indexPath = diffSet.rowsToInsert[0];
    XCTAssert(indexPath.row == 0);
    XCTAssert(indexPath.section == 0);
    indexPath = diffSet.rowsToInsert[1];
    XCTAssert(indexPath.row == 5);
    XCTAssert(indexPath.section == 0);
    indexPath = diffSet.rowsToInsert[2];
    XCTAssert(indexPath.row == 6);
    XCTAssert(indexPath.section == 0);
    indexPath = diffSet.rowsToDelete[0];
    XCTAssert(indexPath.row == 4);
    XCTAssert(indexPath.section == 0);
}

- (void)testInsertionAndDeletionMixInSeveralSections {
    NSArray *objects = @[@{@"key" : @"section 0",@"hash": @"01"},
                         @{@"key" : @"section 0",@"hash": @"02"},
                         @{@"key" : @"section 0.5",@"hash": @"11"},
                         @{@"key" : @"section 0.5",@"hash": @"12"},
                         @{@"key" : @"section 1",@"hash": @"21"},
                         @{@"key" : @"section 1",@"hash": @"22"},
                         @{@"key" : @"section 2",@"hash": @"31"},
                         @{@"key" : @"section 2",@"hash": @"32"}];
    
    BSTableViewModel *tableViewModel = [BSTableViewModel new];
    BSTableViewModelDiffSet *diffSet =  [tableViewModel diffSetForDataArray:objects withSectionKey:@"key"];
    
    objects = @[@{@"key" : @"section 0",@"hash": @"01"},
                @{@"key" : @"section 0",@"hash": @"02"},
                @{@"key" : @"section 0.5",@"hash": @"11"},
                @{@"key" : @"section 0.5",@"hash": @"13"},
                @{@"key" : @"section 3",@"hash": @"21"},
                @{@"key" : @"section 3",@"hash": @"22"},
                @{@"key" : @"section 2",@"hash": @"31"},
                @{@"key" : @"section 2",@"hash": @"32"}];
    
    diffSet =  [tableViewModel diffSetForDataArray:objects withSectionKey:@"key"];
    XCTAssert(diffSet.rowsToInsert.count == 3);
    XCTAssert(diffSet.rowsToDelete.count == 1);
    XCTAssert(diffSet.sectionsToInsert.count == 1);
    XCTAssert(diffSet.sectionsToDelete.count == 1);
}

- (void)testEmptyingOfTable {
    NSArray *objects = @[@1,@2,@3,@4];
    
    BSTableViewModel *tableViewModel = [BSTableViewModel new];
    BSTableViewModelDiffSet *diffSet =  [tableViewModel diffSetForDataArray:objects withSectionKey:nil];
    
    diffSet =  [tableViewModel diffSetForDataArray:nil withSectionKey:nil];
    XCTAssert(diffSet.rowsToInsert.count == 0);
    XCTAssert(diffSet.rowsToDelete.count == 0);
    XCTAssert(diffSet.sectionsToInsert.count == 0);
    XCTAssert(diffSet.sectionsToDelete.count == 1);
}

- (void)testRepeatedInsertionOfSameDataset {
    NSArray *objects = @[@{@"key" : @"section 0",@"hash": @"01"},
                         @{@"key" : @"section 0",@"hash": @"02"},
                         @{@"key" : @"section 0.5",@"hash": @"11"},
                         @{@"key" : @"section 0.5",@"hash": @"13"},
                         @{@"key" : @"section 3",@"hash": @"21"},
                         @{@"key" : @"section 3",@"hash": @"22"},
                         @{@"key" : @"section 2",@"hash": @"31"},
                         @{@"key" : @"section 2",@"hash": @"32"}];
    BSTableViewModel *tableViewModel = [BSTableViewModel new];
    BSTableViewModelDiffSet *diffSet =  [tableViewModel diffSetForDataArray:objects withSectionKey:@"key"];
    diffSet = [tableViewModel diffSetForDataArray:objects withSectionKey:@"key"];
    XCTAssert(diffSet.rowsToInsert.count == 0);
    XCTAssert(diffSet.rowsToDelete.count == 0);
    XCTAssert(diffSet.sectionsToInsert.count == 0);
    XCTAssert(diffSet.sectionsToDelete.count == 0);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

@end
