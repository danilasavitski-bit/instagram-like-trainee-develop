//
//  Category.swift
//  Instagram-like-trainee
//
//  Created by  on 23.12.25.
//
import Foundation

struct Category: Identifiable {
    var id = UUID()
    var title: String
    var items: [CategoryItem]
}

