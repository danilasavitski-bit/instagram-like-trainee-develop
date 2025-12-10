//
//  Urls.swift
//  Instagram-like-trainee
//
//  Created by  on 10.12.25.
//

struct Urls: Codable, Hashable {
    let regular: String
    enum CodingKeys: String, CodingKey {
        case regular
    }
}
