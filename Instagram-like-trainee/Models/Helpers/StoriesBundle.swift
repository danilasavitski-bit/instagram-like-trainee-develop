//
//  StoriesBundle.swift
//  Instagram-like-trainee
//
//  Created by  on 10.12.25.
//
import Foundation

struct StoriesBundle: Identifiable, Hashable {
    let id = UUID()
    let user: User
    var stories: [Story]
}

