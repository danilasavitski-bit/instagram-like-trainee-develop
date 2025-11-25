//
//  JsonService.swift
//  Instagram-like-trainee
//
//  Created by Mikhail Kalatsei on 12/04/2024.
//

import Foundation

final class JsonService { // раз одинаковый и везде используется то мб в синглтон закинуть?

    func fetchFromJson<T: Codable>(objectType: T, filePath: String) -> Result<T, ParseError> {
        if let data = FileManager().contents(atPath: filePath) {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let result = try decoder.decode(T.self, from: data)
                return .success(result)
            } catch {
                return .failure(ParseError.jsonError)
            }
        } else {
            return .failure(ParseError.fileError)
        }
    }
}
