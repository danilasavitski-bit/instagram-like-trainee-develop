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
    let filterManager = ImageFilterManager()
    
    let options: [FilterOption] = [
        FilterOption(filterName: "Normal", filter: .none),
        FilterOption( filterName: "Sepia", filter: .sepia),
        FilterOption( filterName: "Gaussian blur", filter: .blur),
        FilterOption( filterName: "Color invert", filter: .invert),
        FilterOption( filterName: "PhotoEffectMono", filter: .monochrome),
        FilterOption( filterName: "bloom", filter: .bloom)
        
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
    
    func handleTap(option: FilterOption) -> UIImage{
        filterManager.applyFilter(to: originalImage, with: option.filter)
    }
}

struct FilterOption:Identifiable{
    let id = UUID()
    let filterName: String
    let filter: Filters
}
