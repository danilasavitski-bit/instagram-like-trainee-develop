//
//  ParseError.swift
//  Instagram-like-trainee
//
//  Created by Mikhail Kalatsei on 15/04/2024.
//

import Foundation

enum ParseError: Error {
    case fileError
    case jsonError

    var description: String {
        switch self {
        case .fileError:
            "Failed when getting data from file"
        case .jsonError:
            "Failed when decoding data from JSON"
        }
    }
}
