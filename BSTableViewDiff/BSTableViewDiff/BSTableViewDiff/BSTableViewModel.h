//
//  BSTableViewModel.h
//  BSTableViewDiff
//
//  Created by Michael Schwarz on 09.02.15.
//  Copyright (c) 2015 Blacksoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BSTableViewModelDiffSet;

typedef NSString * (^BSTableViewModelSectionTitleBlock)(id object);

@interface BSTableViewModel : NSObject

+ (instancetype)tableViewModel;
+ (instancetype)tableViewModelWithSectionTitleBlock:(BSTableViewModelSectionTitleBlock)block;

- (instancetype)initWithSectionTitleBlock:(BSTableViewModelSectionTitleBlock)block;

- (BSTableViewModelDiffSet *)diffSetForDataArray:(NSArray *)dataArray;

- (NSUInteger)numberOfSections;
- (NSUInteger)numberOfRowsInSection:(NSUInteger)section;
- (NSString *)titleForSection:(NSUInteger)section;
- (id)objectForIndexPath:(NSIndexPath *)indexPath;

@end
