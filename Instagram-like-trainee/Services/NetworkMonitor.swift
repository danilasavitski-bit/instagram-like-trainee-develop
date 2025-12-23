//
//  NetworkMonitor.swift
//  Instagram-like-trainee
//
//  Created by  on 10.12.25.
//
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")

    private(set) var isConnected: Bool = false

    private var continuations: [CheckedContinuation<Void, Never>] = []

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }

            let connected = path.status == .satisfied
            self.isConnected = connected

            if connected {
                self.continuations.forEach { $0.resume() }
                self.continuations.removeAll()
            }
        }

        monitor.start(queue: queue)
    }

    func waitUntilConnected() async {
        if isConnected { return }

        await withCheckedContinuation { continuation in
            continuations.append(continuation)
        }
    }
}
