//
//  CategoryItem.swift
//  Instagram-like-trainee
//
//  Created by  on 23.12.25.
//
import SwiftUI

struct CategoryItem: Identifiable {
    init(id: UUID = UUID(), view: any View) {
        self.view = AnyView(view)
    }
    var id = UUID()
    var view: AnyView
}
