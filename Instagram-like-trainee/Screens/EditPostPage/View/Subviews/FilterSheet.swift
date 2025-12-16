//
//  FilterSheet.swift
//  Instagram-like-trainee
//
//  Created by  on 15.12.25.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct FilterSheet: View {
    @Binding var image: UIImage
    @Binding var isShown: Bool
    let originalImage: UIImage
    
    let options: [FilterOption] = [
        FilterOption(filterName: "Normal"),
        FilterOption( filterName: "Sepia"),
        FilterOption( filterName: "Gaussian blur"),
        FilterOption( filterName: "Color invert"),
        FilterOption( filterName: "PhotoEffectMono"),
        FilterOption( filterName: "bloom")
        
    ]
   
    var body: some View {
        ZStack {
            Color(uiColor: .darkGray)
            VStack{
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(options){ option in
                            customPlate(for: option)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                HStack{
                    Button{
                        image = originalImage
                        isShown = false
                    }label:{
                        Text("Cancel")
                            .padding()
                            .font(.system(size: 11))
                    }
                    
                        .foregroundStyle(.white)
                    Spacer()
                    Text("Filter")
                        .padding()
                        .font(.system(size: 14,weight: .bold))
                        .foregroundStyle(.white)
                    Spacer()
                    Button{
                        isShown = false
                    }label:{
                        Text("Apply")
                            .padding()
                            .font(.system(size: 11))
                    }
                        .foregroundStyle(.white)
                }
            }
        }
        .ignoresSafeArea()
       
            .presentationDragIndicator(.visible)
            .presentationDetents([.height(250)])
            .presentationBackground(.ultraThinMaterial)
    }
    
    func customPlate(for option: FilterOption) -> some View {
        VStack{
            Text(option.filterName)
                .font(.system(size: 11,weight: .medium))
                .foregroundStyle(.white)
            ZStack{
                Image(uiImage: handleTap(option: option))
                    .resizable()
                    }
            .frame(maxWidth:90, maxHeight: 90)
            .mask{
                RoundedRectangle(cornerRadius: 10)
            }
            .onTapGesture {
                self.image = handleTap(option: option)
            }
        }
        .padding(.vertical)
    }
    
    func applySepiaFilter(to image: UIImage) -> UIImage {
        guard let ciImage = CIImage(image: image) else { return image }

            let filter = CIFilter.sepiaTone()
            filter.inputImage = ciImage
            filter.intensity = 1.0

            let context = CIContext()

            guard let outputCIImage = filter.outputImage,
                  let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else {
              return image
            }

            let outputUIImage = UIImage(cgImage: cgImage)

            return outputUIImage
          }
    func applyInverFilter(to image: UIImage) -> UIImage {
        guard let ciImage = CIImage(image: image) else { return image }

            let filter = CIFilter.colorInvert()
            filter.inputImage = ciImage

            let context = CIContext()

            guard let outputCIImage = filter.outputImage,
                  let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else {
              return image
            }

            let outputUIImage = UIImage(cgImage: cgImage)

            return outputUIImage
          }
    func applyGaussianBlurFilter(to image: UIImage) -> UIImage {
        guard let ciImage = CIImage(image: image) else { return image }

        let filter = CIFilter.gaussianBlur()
            filter.inputImage = ciImage

            let context = CIContext()

            guard let outputCIImage = filter.outputImage,
                  let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else {
              return image
            }

            let outputUIImage = UIImage(cgImage: cgImage)

            return outputUIImage
          }
    func applyMonochromeFilter(to image: UIImage) -> UIImage {
        guard let ciImage = CIImage(image: image) else { return image }

        let filter = CIFilter.photoEffectMono()
            filter.inputImage = ciImage

            let context = CIContext()

            guard let outputCIImage = filter.outputImage,
                  let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else {
              return image
            }

            let outputUIImage = UIImage(cgImage: cgImage)

            return outputUIImage
          }
    func applyBloomFilter(to image: UIImage) -> UIImage {
        guard let ciImage = CIImage(image: image) else { return image }

        let filter = CIFilter.bloom()
            filter.inputImage = ciImage

            let context = CIContext()

            guard let outputCIImage = filter.outputImage,
                  let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else {
              return image
            }

            let outputUIImage = UIImage(cgImage: cgImage)

            return outputUIImage
          }
    func applyNormalFilter(to image: UIImage) -> UIImage {
        return originalImage
    }
    
    func handleTap(option: FilterOption) -> UIImage{
        switch option.filterName {
            case "Sepia":
                return applySepiaFilter(to: originalImage)
            case "Normal":
                return applyNormalFilter(to: originalImage)
            case "Gaussian blur":
                return applyGaussianBlurFilter(to: originalImage)
            case "Color invert":
                return  applyInverFilter(to: originalImage)
            case "PhotoEffectMono":
                return applyMonochromeFilter(to: originalImage)
        case "bloom":
                return applyBloomFilter(to: originalImage)
            default:
                return originalImage
        }
    }
}

struct FilterOption:Identifiable{
    let id = UUID()
    var filterName: String
}
