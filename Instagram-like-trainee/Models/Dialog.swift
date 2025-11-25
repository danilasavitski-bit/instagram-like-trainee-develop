//
//  Dialog.swift
//  ModelsTest
//
//  Created by Mikhail Kalatsei on 11/04/2024.
//

import Foundation

struct Dialog: Codable, Identifiable {
    let usersId: [Int]
    var id = UUID()
    let messages: [Message]

    private enum CodingKeys: String, CodingKey {
        case usersId, messages
    }
}
