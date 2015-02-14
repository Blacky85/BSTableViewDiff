//
//  BSTableViewModel.m
//  BSTableViewDiff
//
//  Created by Michael Schwarz on 09.02.15.
//  Copyright (c) 2015 Blacksoft. All rights reserved.
//

#import "BSTableViewModel.h"
#import "BSTableViewModelDiffSet.h"

@interface BSTableViewModel()

@property (nonatomic, strong) NSDictionary *model;
@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) BSTableViewModelSectionNameBlock sectionNameBlock;

@end

@implementation BSTableViewModel

#pragma mark - convinience constructors

+ (instancetype)tableViewModel {
    return [BSTableViewModel tableViewModelWithSectionNameBlock:nil];
}

+ (instancetype)tableViewModelWithSectionNameBlock:(BSTableViewModelSectionNameBlock)block {
    return [[BSTableViewModel alloc] initWithSectionNameBlock:block];
}

#pragma mark - lifecycle

- (instancetype)init {
    return [self initWithSectionNameBlock:nil];
}

- (instancetype)initWithSectionNameBlock:(BSTableViewModelSectionNameBlock)block {
    self = [super init];
    if (self) {
        self.sectionNameBlock = block;
    }
    return self;
}

- (void)dealloc {
    self.sectionNameBlock = nil;
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
