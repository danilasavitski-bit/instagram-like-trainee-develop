//
//  SwiftUIView.swift
//  Instagram-like-trainee
//
//  Created by  on 3.12.25.
//

import SwiftUI

struct SettingsView<Model:SettingsModel>: View {
    @ObservedObject var viewModel: Model
    
    init(viewModel: Model) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            SettingsNavigationView(closeSettings: viewModel.coordinator!.closeSettings)
            Spacer()
            List{
                ForEach(viewModel.categories, id: \.id) { category in
                    Section(category.title) {
                        ForEach(category.items, id: \.id) { item in
                            item.view
                        }
                    }
                }
            }
            .listStyle(.grouped)
            Spacer()
        }
        
    }
}


