//
//  NetworkMonitor.swift
//  Instagram-like-trainee
//
//  Created by  on 10.12.25.
//
import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")

    public private(set) var isConnected: Bool = false

    var onConnect: (() -> Void)?
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            self.isConnected = (path.status == .satisfied)

            if self.isConnected {
                self.onConnect?()
                self.onConnect = nil
            }
        }
        monitor.start(queue: queue)
    }
}
