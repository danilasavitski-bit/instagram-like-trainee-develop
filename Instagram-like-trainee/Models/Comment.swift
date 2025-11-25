//
//  Comment.swift
//  ModelsTest
//
//  Created by Mikhail Kalatsei on 11/04/2024.
//

import Foundation

struct Comment: Codable {
    let text: String
    let likes: Int
    let userId: Int
}
