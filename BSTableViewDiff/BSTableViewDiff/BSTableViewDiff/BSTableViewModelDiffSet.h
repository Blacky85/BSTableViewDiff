//
//  BSTableViewModelDiffSet.h
//  BSTableViewDiff
//
//  Created by Michael Schwarz on 09.02.15.
//  Copyright (c) 2015 Blacksoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSTableViewModelDiffSet : NSObject

@property (nonatomic, readonly) BOOL hasUpdates;

@property (nonatomic, strong) NSArray *rowsToInsert;
@property (nonatomic, strong) NSIndexSet *sectionsToInsert;
@property (nonatomic, strong) NSArray *rowsToDelete;
@property (nonatomic, strong) NSIndexSet *sectionsToDelete;

@end
