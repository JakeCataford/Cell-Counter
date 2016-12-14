//
//  SearchParams.h
//  Cell Counter
//
//  Created by Jake Cataford on 2016-12-18.
//  Copyright © 2016 Jake Cataford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <cocoa/cocoa.h>

@interface SearchParams : NSObject

@property NSColor *searchColor;

@property float minDistance;

@property bool filterByArea;
@property float minArea;
@property float maxArea;

@property bool filterByInertia;
@property float minInertiaRatio;
@property float maxInertiaRatio;

@property bool filterByConvexity;
@property float minConvexity;
@property float maxConvexity;

@property float minThreshold;
@property float maxThreshold;

@end
