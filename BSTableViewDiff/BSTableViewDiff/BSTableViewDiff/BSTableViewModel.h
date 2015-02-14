//
//  BSTableViewModel.h
//  BSTableViewDiff
//
//  Created by Michael Schwarz on 09.02.15.
//  Copyright (c) 2015 Blacksoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BSTableViewModelDiffSet;

@interface BSTableViewModel : NSObject

- (BSTableViewModelDiffSet *)diffSetForDataArray:(NSArray *)dataArray withSectionKey:(NSString *)key;

@end
