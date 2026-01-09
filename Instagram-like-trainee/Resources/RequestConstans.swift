//
//  RequestConstans.swift
//  Instagram-like-trainee
//
//  Created by  on 9.01.26.
//
import Foundation

struct RequestConstants {
    static private let videoKeyValue = "videoKey"
    static func returnClientId() -> String {
        guard let clientId = Bundle.main.object(forInfoDictionaryKey: "IMAGES_API_KEY") as? String else {
            print("client API key not found")
            return ""
        }
        return clientId
    }
    static func returnVideoKey() -> String {
        guard let videoAPIKey = Bundle.main.object(forInfoDictionaryKey: "VIDEO_API_KEY") as? String else {
            print("video API key not found")
            return ""
        }
        return videoAPIKey
        
    }
}
