//
//  CIImageHelper.swift
//  Excavator
//
//  Created by Pavel Stepanov on 04.05.20.
//  Copyright © 2020 Tomorrow GmbH. All rights reserved.
//

import CoreImage.CIImage
import AVFoundation

enum CIImageHelper {

    private static let scaleFactor = 0.75

    static func make(from sampleBuffer: CMSampleBuffer, targetProportionRect: CGRect) -> CIImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return nil
        }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)

        guard let croppedImage = crop(ciImage: ciImage, to: targetProportionRect) else {
            return nil
        }

        return scale(image: croppedImage, scale: self.scaleFactor)?.oriented(.right)
    }

    private static func crop(ciImage: CIImage, to proportions: CGRect) -> CIImage? {
        let cropRect = CGRect(x: proportions.minY * ciImage.extent.width,
                              y: proportions.minX * ciImage.extent.height,
                              width: proportions.height * ciImage.extent.width,
                              height: proportions.width * ciImage.extent.height)
        guard cropRect != CGRect.zero else {
            return nil
        }
        return ciImage.cropped(to: cropRect)
    }

    private static func scale(image: CIImage, scale: Double) -> CIImage? {
        let filter = CIFilter(name: "CILanczosScaleTransform")
        filter?.setValue(image, forKey: "inputImage")
        filter?.setValue(scale, forKey: "inputScale")
        filter?.setValue(1, forKey: "inputAspectRatio")

        return filter?.outputImage
    }
}
