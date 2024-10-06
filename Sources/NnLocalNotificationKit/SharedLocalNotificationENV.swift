//
//  SharedLocalNotificationENV.swift
//
//
//  Created by Nikolai Nobadi on 10/5/24.
//

import Foundation
import UserNotifications

final class SharedLocalNotificationENV: ObservableObject {
    @Published var permissionGranted = false
    
    private let options: UNAuthorizationOptions
    
    init(options: UNAuthorizationOptions) {
        self.options = options
    }
}


// MARK: - Actions
extension SharedLocalNotificationENV {
    func requestPermission() {
        Task {
            let granted = await SharedLocalNotificationManager.requestAuthPermission(options: options)
            
            await MainActor.run {
                permissionGranted = granted
            }
        }
    }
}
