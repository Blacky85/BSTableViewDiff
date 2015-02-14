//
//  ExampleModelObject.m
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

#import "ExampleModelObject.h"

@implementation ExampleModelObject

+ (instancetype)modelWithSection:(NSString *)section name:(NSString *)name {
    ExampleModelObject *exampleModel = [[ExampleModelObject alloc] init];
    exampleModel->_name = name;
    exampleModel->_section = section;
    return exampleModel;
}

- (BOOL)isEqual:(ExampleModelObject *)object {
    if (![object isKindOfClass:self.class]) {
        return NO;
    }
    
    if (self == object) {
        return YES;
    }
    
    if ([self.name isEqualToString:object.name]) {
        return YES;
    }
    return NO;
}

- (UIColor *)color {
    if (self.name.length == 0) {
        return [UIColor blackColor];
    }

    UIColor *color0 = [UIColor colorWithRed:39.f/255.f green:60.f/255.f blue:73.f/255.f alpha:1.f];
    UIColor *color1 = [UIColor colorWithRed:58.f/255.f green:164.f/255.f blue:139.f/255.f alpha:1.f];
    UIColor *color2 = [UIColor colorWithRed:234.f/255.f green:191.f/255.f blue:60.f/255.f alpha:1.f];
    UIColor *color3 = [UIColor colorWithRed:217.f/255.f green:101.f/255.f blue:49.f/255.f alpha:1.f];
    UIColor *color4 = [UIColor colorWithRed:213.f/255.f green:49.f/255.f blue:57.f/255.f alpha:1.f];
    UIColor *color5 = [UIColor colorWithRed:201.f/255.f green:90.f/255.f blue:70.f/255.f alpha:1.f];
    UIColor *color6 = [UIColor colorWithRed:58.f/255.f green:62.f/255.f blue:94.f/255.f alpha:1.f];
    UIColor *color7 = [UIColor colorWithRed:143.f/255.f green:65.f/255.f blue:87.f/255.f alpha:1.f];
    
    
    NSArray *colors = @[color0,color1,color2,color3,color4,color5,color6,color7];
    unichar character = [self.name characterAtIndex:0];
    NSUInteger index = character % 8;
    return [colors objectAtIndex:index];
}

@end
