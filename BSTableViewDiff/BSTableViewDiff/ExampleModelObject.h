//
//  ExampleModelObject.h
//  BSTableViewDiff
//
//  Created by Michael Schwarz on 14.02.15.
//  Copyright (c) 2015 Blacksoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ExampleModelObject : NSObject

+ (instancetype)modelWithSection:(NSString *)section name:(NSString *)name;

@property (nonatomic, readonly) NSString *section;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) UIColor *color;

@end
