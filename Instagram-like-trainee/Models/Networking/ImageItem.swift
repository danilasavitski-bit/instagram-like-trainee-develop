//
//  ImageItem.swift
//  Instagram-like-trainee
//
//  Created by  on 10.12.25.
//

struct ImageItem: Codable, Hashable {
    let urls: Urls
    enum CodingKeys: String, CodingKey {
        case urls
    }
}
