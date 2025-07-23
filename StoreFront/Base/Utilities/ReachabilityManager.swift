//
//  ReachabilityManager.swift
//  StoreFront
//
//  Created by Wafaa Farrag on 20/07/2025.
//

import Foundation
import Reachability

final class ReachabilityManager {
    static let shared = ReachabilityManager()
    
    private let reachability: Reachability
    
    private init() {
        do {
            reachability = try Reachability()
        } catch {
            fatalError("❌ Unable to initialize Reachability: \(error.localizedDescription)")
        }
    }
    
    var isConnected: Bool {
        return reachability.connection != .unavailable
    }
    
    func startMonitoring() {
        reachability.whenReachable = { _ in
            Logger.log("✅ Network reachable")
        }
        
        reachability.whenUnreachable = { _ in
            Logger.log("❌ Network not reachable")
            self.handleNetworkUnavailable()
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            Logger.log("⚠️ Unable to start notifier: \(error.localizedDescription)")
            SwiftMessagesService.show(message: "Unable to monitor network", theme: .error)
        }
    }
    
    private func handleNetworkUnavailable() {
        SwiftMessagesService.show(message: "No Internet Connection", theme: .error)
    }
}
