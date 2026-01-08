//
//  ImageFilterManager.swift
//  Instagram-like-trainee
//
//  Created by  on 8.01.26.
//
import UIKit

enum Filters{
    case sepia
    case bloom
    case invert
    case blur
    case monochrome
    case none
}

class ImageFilterManager {
    func applyFilter(to image: UIImage, with filter: Filters) -> UIImage {
        guard let ciImage = CIImage(image: image) else { return image }
        let context = CIContext()
        var imageToReturn: UIImage = image
        switch filter {
        case .bloom:
            imageToReturn = applyBloomFilter(to: ciImage, context: context)
        case .blur:
            imageToReturn = applyBlurFilter(to: ciImage, context: context)
        case .invert:
            imageToReturn = applyInvertFilter(to: ciImage, context: context)
        case .monochrome:
            imageToReturn = applyMonoFilter(to: ciImage, context: context)
        case .sepia:
            imageToReturn = applySepiaFilter(to: ciImage, context: context)
        case .none:
            imageToReturn = image
        }
        return imageToReturn
    }
    
    private func createFilteredImage(with filter: CIFilter, in context: CIContext) -> UIImage {
        guard let outputCIImage = filter.outputImage,
              let cgImage = context.createCGImage(outputCIImage,
                                                  from: outputCIImage.extent) else { return UIImage() }
        return UIImage(cgImage: cgImage)
    }
    
    private func applyBloomFilter(to image: CIImage, context: CIContext) -> UIImage {
        let filter = CIFilter.bloom()
        filter.inputImage = image
        return createFilteredImage(with: filter, in: context)
    }
    private func applyBlurFilter(to image: CIImage, context: CIContext) -> UIImage {
        let filter = CIFilter.gaussianBlur()
        filter.inputImage = image
        return createFilteredImage(with: filter, in: context)
    }
    private func applyInvertFilter(to image: CIImage, context: CIContext) -> UIImage {
        let filter = CIFilter.colorInvert()
        filter.inputImage = image
        return createFilteredImage(with: filter, in: context)
    }
    private func applyMonoFilter(to image: CIImage, context: CIContext) -> UIImage {
        let filter = CIFilter.photoEffectMono()
        filter.inputImage = image
        return createFilteredImage(with: filter, in: context)
    }
    private func applySepiaFilter(to image: CIImage, context: CIContext) -> UIImage {
        let filter = CIFilter.sepiaTone()
        filter.inputImage = image
        filter.intensity = 1.0
        return createFilteredImage(with: filter, in: context)
    }
}
