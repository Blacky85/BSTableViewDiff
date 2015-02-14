//
//  BSTableViewModel.h
//  BSTableViewDiff
//
//  Created by Michael Schwarz on 09.02.15.
//  Copyright (c) 2015 Blacksoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BSTableViewModelDiffSet;

typedef NSString * (^BSTableViewModelSectionNameBlock)(id object);

@interface BSTableViewModel : NSObject

+ (instancetype)tableViewModel;
+ (instancetype)tableViewModelWithSectionNameBlock:(BSTableViewModelSectionNameBlock)block;

- (instancetype)initWithSectionNameBlock:(BSTableViewModelSectionNameBlock)block;

- (BSTableViewModelDiffSet *)diffSetForDataArray:(NSArray *)dataArray;

@end
