//
//  UITableView+BSTableViewModelDiffSet.h
//  BSTableViewDiff
//
//  Created by Michael Schwarz on 14.02.15.
//  Copyright (c) 2015 Blacksoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSTableViewModelDiffSet;

@interface UITableView (BSTableViewModelDiffSet)

- (void)applyDiffSet:(BSTableViewModelDiffSet *)diffSet;

@end
