//
//  OpenCV.m
//  Cell Counter
//
//  Created by Jake Cataford on 2016-12-14.
//  Copyright © 2016 Jake Cataford. All rights reserved.
//

#import "OpenCV.h"
#import <opencv2/opencv.hpp>
#import "NSImage+OpenCV.h"
#import <coreimage/coreimage.h>

using namespace cv;
using namespace std;

@implementation OpenCV

+ (CellCountResult *) detectBlobsInImage:(NSImage*)inputImage
                              withParams:(SearchParams*)params
{
    NSImage *preparedImage = [self prepareImage:inputImage];
    
    Mat mat = [preparedImage CVGrayscaleMat];
    
    SimpleBlobDetector::Params cvparams;
    cvparams.minDistBetweenBlobs = params.minDistance;
    
    cvparams.filterByColor = true;
    cvparams.blobColor = 255;
    
    cvparams.filterByArea = params.filterByArea;
    cvparams.minArea = params.minArea;
    cvparams.maxArea = params.maxArea;
    
    cvparams.filterByInertia = params.filterByInertia;
    cvparams.minInertiaRatio = params.minInertiaRatio;
    cvparams.maxInertiaRatio = params.maxInertiaRatio;
    
    cvparams.filterByConvexity = params.filterByConvexity;
    cvparams.minConvexity = params.minConvexity;
    cvparams.maxConvexity = params.maxConvexity;
    
    cvparams.minThreshold = params.minThreshold;
    cvparams.maxThreshold = params.maxThreshold;
    
    Ptr<SimpleBlobDetector> blob_detector = SimpleBlobDetector::create(cvparams);
    
    vector<cv::KeyPoint> keypoints;
    blob_detector->detect(mat, keypoints);
    
    Mat mat_with_keypoints;
    drawKeypoints(mat, keypoints, mat_with_keypoints, Scalar(0,255,255), 4);
    
    CellCountResult * result = [[CellCountResult alloc] init];
    result.markedImage = [NSImage imageWithCVMat: mat_with_keypoints];
    result.numberOfCellsCounted = keypoints.size();
    return result;
}

+ (NSImage *) prepareImage:(NSImage *)image
{
    CIImage *imageToProcess = [[CIImage alloc] initWithData:image.TIFFRepresentation];
    
    CIFilter *colorControlsFilter = [CIFilter filterWithName:@"CIColorControls"];
    [colorControlsFilter setDefaults];
    [colorControlsFilter setValue:imageToProcess forKey:@"inputImage"];
    [colorControlsFilter setValue:[NSNumber numberWithFloat:0.0] forKey:@"inputSaturation"];
    [colorControlsFilter setValue:[NSNumber numberWithFloat:1.0] forKey:@"inputContrast"];
    
    CIFilter *unsharpFilter = [CIFilter filterWithName:@"CIUnsharpMask"];
    [unsharpFilter setDefaults];
    [unsharpFilter setValue:colorControlsFilter.outputImage forKey:@"inputImage"];
    [unsharpFilter setValue:[NSNumber numberWithFloat:4.0] forKey:@"inputIntensity"];
    
    NSCIImageRep *rep = [NSCIImageRep imageRepWithCIImage: unsharpFilter.outputImage];
    NSImage *nsImage = [[NSImage alloc] initWithSize:rep.size];
    [nsImage addRepresentation:rep];
    return nsImage;
}

+ (uint) uintFromNSColor:(NSColor *) color
{
    CGFloat red, green, blue;
    
    [color getRed:&red green:&green blue:&blue alpha:NULL];
    
    uint redInt = red * 255 + 0.5;
    uint greenInt = green * 255 + 0.5;
    uint blueInt = blue * 255 + 0.5;
        
    return (redInt << 16) | (greenInt << 8) | blueInt;
}


@end
