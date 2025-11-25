//
//  Story.swift
//  ModelsTest
//
//  Created by Mikhail Kalatsei on 11/04/2024.
//

import Foundation

struct Story: Codable {
    let userId: Int
    let content: URL
    let id: Int
    let dateAdded: Date
}
