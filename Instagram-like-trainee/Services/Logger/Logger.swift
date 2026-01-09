//
//  Logger.swift
//  Instagram-like-trainee
//
//  Created by  on 9.01.26.
//
import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier ?? "com.example.Instagram-like-trainee"
    
    static let network = Logger(subsystem: subsystem, category: "network")
    
    static let viewModel = Logger(subsystem: subsystem, category: "viewModel")
    
    static let view = Logger(subsystem: subsystem, category: "view")
}
