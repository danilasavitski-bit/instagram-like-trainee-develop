//
//  SwiftUIView.swift
//  Instagram-like-trainee
//
//  Created by  on 3.12.25.
//

import SwiftUI

struct SettingsView<Model:SettingsModel>: View {
    @ObservedObject var viewModel: Model
    let categories: [Category] = [
        Category(title: "Your account",
                 items: [
                    CategoryItem(view: AccountCellView())
                 ]),
        Category(title: "How you use instagram",
                 items: [
                    CategoryItem(view: SettingsCellView(image: "bookmark",
                                                        text: "Saved")),
                    CategoryItem(view: SettingsCellView(image: "clock.arrow.trianglehead.clockwise.rotate.90.path.dotted",
                                                        text: "Archive")),
                    CategoryItem(view: SettingsCellView(image: "waveform.path.ecg.rectangle",
                                                        text: "Your actions")),
                    CategoryItem(view: SettingsCellView(image: "bell",
                                                        text: "Notifications")),
                    CategoryItem(view: SettingsCellView(image: "clock",
                                                        text: "Time menegment"))
                 ]),
        Category(title: "Who can see your content",
                 items: [
                    CategoryItem(view: Text("Example"))
                 ]),
        Category(title: "Your accecability",
                 items: [
                    CategoryItem(view: Text("Example"))
                 ]),
        Category(title: "What you see",
                 items: [
                    CategoryItem(view: Text("Example"))
                 ]),
        Category(title: "Your app and media",
                 items: [
                    CategoryItem(view: Text("Example"))
                 ]),
        Category(title: "Family center",
                 items: [
                    CategoryItem(view: Text("Example"))
                 ]),
        Category(title: "For proffesional accounts",
                 items: [
                    CategoryItem(view: Text("Example"))
                 ]),
        Category(title: "Your orders and charings",
                  items: [
                     CategoryItem(view: Text("Example"))
                  ]),
        Category(title: "Information and support",
                  items: [
                     CategoryItem(view: Text("Example"))
                  ]),
        Category(title: "Other Meta products",
                  items: [
                     CategoryItem(view: Text("Example"))
                  ])
        
    ]
    
    init(viewModel: Model) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            SettingsNavigationView(closeSettings: viewModel.coordinator!.didPressCloseSettings)
            Spacer()
            List{
                ForEach(categories, id: \.id) { category in
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

struct Category: Identifiable {
    var id = UUID()
    var title: String
    var items: [CategoryItem]
}
struct CategoryItem: Identifiable {
    init(id: UUID = UUID(), view: any View) {
        self.view = AnyView(view)
    }
    var id = UUID()
    var view: AnyView
}
