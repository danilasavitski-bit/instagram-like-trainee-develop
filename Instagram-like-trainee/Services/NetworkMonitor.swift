//
//  NetworkMonitor.swift
//  Instagram-like-trainee
//
//  Created by  on 10.12.25.
//
import Network

actor NetworkMonitor {
    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")

    private var isConnected = false
    private var continuations: [CheckedContinuation<Void, Never>] = []

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            Task {
                await self?.handle(path: path)
            }
        }

        monitor.start(queue: queue)
    }

    private func handle(path: NWPath) {
        let connected = path.status == .satisfied
        isConnected = connected

        if connected {
            continuations.forEach { $0.resume() }
            continuations.removeAll()
        }
    }

    func waitUntilConnected() async {
        if isConnected { return }

        await withCheckedContinuation { continuation in
            continuations.append(continuation)
        }
    }
}
