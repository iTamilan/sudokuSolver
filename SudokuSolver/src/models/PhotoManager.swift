//
//  PhotoManager.swift
//  SudokuSolver
//
//  Created by Tamilarasu on 09/04/2017.
//  Copyright © 2017 iTamilan. All rights reserved.
//

import UIKit
import Vision

class PhotoManager: NSObject {
    static var sharedInstanceObj:PhotoManager? = nil
    static func sharedInstance()->PhotoManager{
        if PhotoManager.sharedInstanceObj == nil {
            PhotoManager.sharedInstanceObj = PhotoManager.init()
        }
        return PhotoManager.sharedInstanceObj!
    }
    
    func processImageWithVision(image: UIImage) {
        let textRequest = VNDetectTextRectanglesRequest { (request, error) in
            if let results = request.results as? [VNTextObservation] {
                for textObservation in results {
                    print("Text observation : \(textObservation)")
                    if let rectangleBoxes = textObservation.characterBoxes {
                        for rectangleBox in rectangleBoxes {
                            print("Rectangle box: \(rectangleBox))")
                        }
                    }
                }
            }
        }
        
        textRequest.reportCharacterBoxes = true
        
        guard let ciimage = CIImage(image: image) else {
            return
        }
        let imageRequestHandler = VNImageRequestHandler(ciImage: ciimage, options: [:])
        do {
            try imageRequestHandler.perform([textRequest])
        } catch {
            print("Error while finding the rect \(error)")
        }
    }
    
    func processImage(image:UIImage)->UIImage{
        
//        processImage(image: image)
//        return
//        print(image)
        let detector:CIDetector = CIDetector.init(ofType: CIDetectorTypeRectangle, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])!
        let newImage = CIImage.init(image: image)
        let copiedImage:UIImage = image.copy() as! UIImage
        let features:Array<CIFeature> = detector.features(in: newImage!)
        var imageRect = CGRect.init(origin: CGPoint.zero, size: image.size)
        if let feature = features.first as? CIRectangleFeature {
            imageRect = feature.bounds
        }
//        UIGraphicsBeginImageContext(image.size)
//
//
//        image.draw(in: imageRect, blendMode: .normal, alpha: 1.0)
//        let context = UIGraphicsGetCurrentContext()
////        var returnImage = CIImage.init(image: image)
//        var rect = imageRect
//
//        for  feature  in features where features.count == 1 {
////            let textFeature:CITextFeature = feature as! CITextFeature
//            let rectangleFeature:CIRectangleFeature = feature as! CIRectangleFeature
//            rect = rectangleFeature.bounds
//            let topLeftPoint = rectangleFeature.topLeft
//            print(rectangleFeature,"  ",topLeftPoint)
//            context?.saveGState()
//            UIGraphicsEndImageContext();
//
//}
        
        let convertedRect = invertRect(rect: imageRect, completeImageSize: copiedImage.size)
        
        let imageRef:CGImage = copiedImage.cgImage!.cropping(to: convertedRect)!
        let croppedImage:UIImage = UIImage(cgImage:imageRef)
        
        let copiedCroppedImage = CIImage.init(image: croppedImage)
        
        
        
        let textDetector:CIDetector = CIDetector.init(ofType: CIDetectorTypeText, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])!
        
        let textFeatures:Array<CIFeature> = textDetector.features(in: copiedCroppedImage!)
        
        for feature in textFeatures {
            if let feature = feature as? CITextFeature {
                print("feature list \(feature)")
            }
        }
        
        return croppedImage;
        
    }
    
    func invertRect(rect: CGRect, completeImageSize: CGSize) -> CGRect {
        let size = rect.size
        let x = rect.origin.x
        let y = completeImageSize.height - rect.maxY
        return CGRect(origin: CGPoint(x: x, y: y), size: size)
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
