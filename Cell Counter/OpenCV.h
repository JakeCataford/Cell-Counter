//
//  OpenCV.h
//  Cell Counter
//
//  Created by Jake Cataford on 2016-12-14.
//  Copyright © 2016 Jake Cataford. All rights reserved.
//
#ifdef __cplusplus
#import <opencv2/core/core.hpp>
#endif

#import <Foundation/Foundation.h>
#import <cocoa/cocoa.h>
#import "CellCountResult.h"
#import "SearchParams.h"

@interface OpenCV : NSObject
+ (CellCountResult *) detectBlobsInImage:(NSImage*)inputImage
                              withParams:(SearchParams*)params;


@end
