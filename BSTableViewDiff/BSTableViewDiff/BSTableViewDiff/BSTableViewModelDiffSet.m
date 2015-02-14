//
//  BSTableViewModelDiffSet.m
//  BSTableViewDiff
//
//  Created by Michael Schwarz on 09.02.15.
//  Copyright (c) 2015 Blacksoft. All rights reserved.
//

#import "BSTableViewModelDiffSet.h"

@implementation BSTableViewModelDiffSet

- (BOOL)hasUpdates {
    if (self.rowsToDelete.count > 0 || self.rowsToInsert.count > 0 ||
        self.sectionsToDelete.count > 0 || self.rowsToDelete.count > 0) {
        return YES;
    }
    return NO;
}

@end
