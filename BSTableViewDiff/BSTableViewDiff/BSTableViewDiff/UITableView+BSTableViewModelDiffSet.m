//
//  UITableView+BSTableViewModelDiffSet.m
//  BSTableViewDiff
//
//  Created by Michael Schwarz on 14.02.15.
//  Copyright (c) 2015 Blacksoft. All rights reserved.
//

#import "UITableView+BSTableViewModelDiffSet.h"
#import "BSTableViewModelDiffSet.h"

@implementation UITableView (BSTableViewModelDiffSet)

- (void)applyDiffSet:(BSTableViewModelDiffSet *)diffSet {
    if (diffSet.hasUpdates) {
        [self beginUpdates];
        if (diffSet.sectionsToDelete.count > 0) {
            [self deleteSections:diffSet.sectionsToDelete withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        if (diffSet.rowsToDelete.count > 0) {
            [self deleteRowsAtIndexPaths:diffSet.rowsToDelete withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        if (diffSet.sectionsToInsert) {
            [self insertSections:diffSet.sectionsToInsert withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        if (diffSet.rowsToInsert) {
            [self insertRowsAtIndexPaths:diffSet.rowsToInsert withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        [self endUpdates];
    }
}

@end
