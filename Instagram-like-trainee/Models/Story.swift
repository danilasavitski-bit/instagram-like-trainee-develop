//
//  Story.swift
//  ModelsTest
//
//  Created by Mikhail Kalatsei on 11/04/2024.
//

import Foundation

struct Story: Codable,Identifiable, Hashable {
    let userId: Int
    let content: URL
    let id: String
    let dateAdded: Date
    var isSeen: Bool = false
    
    mutating func seenStory() {
        isSeen = true
    }
}
