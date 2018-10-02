//
//  PhotoManager.swift
//  SudokuSolver
//
//  Created by Tamilarasu on 09/04/2017.
//  Copyright © 2017 iTamilan. All rights reserved.
//

import UIKit

class PhotoManager: NSObject {
    static var sharedInstanceObj:PhotoManager? = nil
    static func sharedInstance()->PhotoManager{
        if PhotoManager.sharedInstanceObj == nil {
            PhotoManager.sharedInstanceObj = PhotoManager.init()
        }
        return PhotoManager.sharedInstanceObj!
    }
    func processImage(image:UIImage)->UIImage{
        print(image)
        let detector:CIDetector = CIDetector.init(ofType: CIDetectorTypeText, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])!
        let newImage = CIImage.init(image: image)
        let copiedImage:UIImage = image.copy() as! UIImage
        let features:Array<CIFeature> = detector.features(in: newImage!)
        UIGraphicsBeginImageContext(image.size)
        let imageRect = CGRect.init(origin: CGPoint.zero, size: image.size)
        
        image.draw(in: imageRect, blendMode: .normal, alpha: 1.0)
        let context = UIGraphicsGetCurrentContext()
//        var returnImage = CIImage.init(image: image)
        var rect = imageRect
        
        for  feature  in features where features.count == 1 {
//            let textFeature:CITextFeature = feature as! CITextFeature
            let rectangleFeature:CIRectangleFeature = feature as! CIRectangleFeature
            rect = rectangleFeature.bounds
            let topLeftPoint = rectangleFeature.topLeft
            print(rectangleFeature,"  ",topLeftPoint)
            context?.saveGState()
            UIGraphicsEndImageContext();

        }
        let imageRef:CGImage = copiedImage.cgImage!.cropping(to: rect)!
        let croppedImage:UIImage = UIImage(cgImage:imageRef)
        return croppedImage;
        
    }
    /*
    - (UIImage *)faceOverlayImageFromImage:(UIImage *)image
    {
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
    context:nil
    options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    // Get features from the image
    CIImage* newImage = [CIImage imageWithCGImage:image.CGImage];
    
    NSArray *features = [detector featuresInImage:newImage];
    
    UIGraphicsBeginImageContext(image.size);
    CGRect imageRect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    
    //Draws this in the upper left coordinate system
    [image drawInRect:imageRect blendMode:kCGBlendModeNormal alpha:1.0f];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (CIFaceFeature *faceFeature in features) {
    CGRect faceRect = [faceFeature bounds];
    CGContextSaveGState(context);
    
    // CI and CG work in different coordinate systems, we should translate to
    // the correct one so we don't get mixed up when calculating the face position.
    CGContextTranslateCTM(context, 0.0, imageRect.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    
    if ([faceFeature hasLeftEyePosition]) {
    CGPoint leftEyePosition = [faceFeature leftEyePosition];
    CGFloat eyeWidth = faceRect.size.width / kFaceBoundsToEyeScaleFactor;
    CGFloat eyeHeight = faceRect.size.height / kFaceBoundsToEyeScaleFactor;
    CGRect eyeRect = CGRectMake(leftEyePosition.x - eyeWidth/2.0f,
    leftEyePosition.y - eyeHeight/2.0f,
    eyeWidth,
    eyeHeight);
    [self drawEyeBallForFrame:eyeRect];
    }
    
    if ([faceFeature hasRightEyePosition]) {
    CGPoint leftEyePosition = [faceFeature rightEyePosition];
    CGFloat eyeWidth = faceRect.size.width / kFaceBoundsToEyeScaleFactor;
    CGFloat eyeHeight = faceRect.size.height / kFaceBoundsToEyeScaleFactor;
    CGRect eyeRect = CGRectMake(leftEyePosition.x - eyeWidth / 2.0f,
    leftEyePosition.y - eyeHeight / 2.0f,
    eyeWidth,
    eyeHeight);
    [self drawEyeBallForFrame:eyeRect];
    }
    
    CGContextRestoreGState(context);
    }
    
    UIImage *overlayImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return overlayImage;
    }
*/
}
