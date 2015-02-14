//
//  BSTableViewModel.m
//  BSTableViewDiff
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 Michael Schwarz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "BSTableViewModel.h"
#import "BSTableViewModelDiffSet.h"
#import <UIKit/UIKit.h>

@interface BSTableViewModel()

@property (nonatomic, strong) NSDictionary *model;
@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) BSTableViewModelSectionTitleBlock sectionNameBlock;

@end

@implementation BSTableViewModel

#pragma mark - convinience constructors

+ (instancetype)tableViewModel {
    return [BSTableViewModel tableViewModelWithSectionTitleBlock:nil];
}

+ (instancetype)tableViewModelWithSectionTitleBlock:(BSTableViewModelSectionTitleBlock)block {
    return [[BSTableViewModel alloc] initWithSectionTitleBlock:block];
}

#pragma mark - lifecycle

- (instancetype)init {
    return [self initWithSectionTitleBlock:nil];
}

- (instancetype)initWithSectionTitleBlock:(BSTableViewModelSectionTitleBlock)block {
    self = [super init];
    if (self) {
        self.sectionNameBlock = block;
    }
    return self;
}

- (void)dealloc {
    self.sectionNameBlock = nil;
}

#pragma mark - data access

- (NSUInteger)numberOfSections {
    return self.sections.count;
}

- (NSUInteger)numberOfRowsInSection:(NSUInteger)section {
    NSString *sectionName = [self titleForSection:section];
    return [self.model[sectionName] count];
}

- (NSString *)titleForSection:(NSUInteger)section {
    return self.sections[section];
}

- (id)objectForIndexPath:(NSIndexPath *)indexPath {
    NSString *sectionName = [self titleForSection:indexPath.section];
    NSArray *objects = self.model[sectionName];
    return objects[indexPath.row];
}

#pragma mark - diffset calculation

- (BSTableViewModelDiffSet *)diffSetForDataArray:(NSArray *)dataArray {
    BSTableViewModelDiffSet *diffset = [BSTableViewModelDiffSet new];
    NSDictionary *oldModel = self.model;
    NSArray *oldSections = self.sections;
    
    if (dataArray) {
        if (self.sectionNameBlock) {
            [self groupObjectsInArray:dataArray];
        } else {
            self.model = @{[NSNull null] : dataArray};
            self.sections = @[[NSNull null]];
        }
    } else {
        self.model = nil;
        self.sections = nil;
    }
    
    //Calculate Sections & Cells to Delete
    NSMutableArray *rowsToDelete = [NSMutableArray new];
    NSMutableIndexSet *sectionsToDelete = [NSMutableIndexSet new];
    NSUInteger sectionNumber = 0;
    for (NSString *sectionKey in oldSections) {
        NSArray *section = [self.model objectForKey:sectionKey];
        NSArray *oldSection = [oldModel objectForKey:sectionKey];
        NSUInteger row = 0;
        if (!section) {
            [sectionsToDelete addIndex:sectionNumber];
        } else {
            for (id obj in oldSection) {
                if (![section containsObject:obj]) {
                    NSUInteger indexes[] = {sectionNumber, row};
                    [rowsToDelete addObject:[NSIndexPath indexPathWithIndexes:indexes length:2]];
                }
                row++;
            }
        }
        sectionNumber++;
    }
    diffset.rowsToDelete = rowsToDelete.copy;
    diffset.sectionsToDelete = sectionsToDelete.copy;
    
    //Calculate Sections & Rows to Insert
    NSMutableArray *rowsToInsert = [NSMutableArray new];
    NSMutableIndexSet *sectionsToInsert = [NSMutableIndexSet new];
    sectionNumber = 0;
    for (NSString *sectionKey in self.sections) {
        NSArray *section = [self.model objectForKey:sectionKey];
        NSArray *oldSection = [oldModel objectForKey:sectionKey];
        if (!oldSection) {
            [sectionsToInsert addIndex:sectionNumber];
        }
        NSUInteger row = 0;
        for (id obj in section) {
            if (![oldSection containsObject:obj]) {
                NSUInteger indexes[] = {sectionNumber, row};
                [rowsToInsert addObject:[NSIndexPath indexPathWithIndexes:indexes length:2]];
            }
            row++;
        }
        sectionNumber++;
    }
    diffset.rowsToInsert = rowsToInsert.copy;
    diffset.sectionsToInsert = sectionsToInsert.copy;
    
    return diffset;
}

#pragma mark - private

- (void)groupObjectsInArray:(NSArray *)array {
    NSMutableDictionary *groupsDict = [NSMutableDictionary new];
    NSMutableArray *sections = [NSMutableArray new];
    
    for (id obj in array) {
        NSString *groupKey = self.sectionNameBlock(obj);
        NSAssert([groupKey isKindOfClass:[NSString class]], @"Section Name Block must return a NSString Value");
        
        NSMutableArray *groupedArray = [groupsDict valueForKey:groupKey];
        if (!groupedArray) {
            [sections addObject:groupKey];
            groupedArray = [NSMutableArray new];
            [groupsDict setValue:groupedArray forKey:groupKey];
        }
        [groupedArray addObject:obj];
    }
    self.model = groupsDict.copy;
    self.sections = sections.copy;
}

@end
