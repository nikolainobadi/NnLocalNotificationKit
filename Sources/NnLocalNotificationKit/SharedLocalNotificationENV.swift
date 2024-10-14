//
//  SharedLocalNotificationENV.swift
//
//
//  Created by Nikolai Nobadi on 10/5/24.
//

import Foundation
import UserNotifications

final class SharedLocalNotificationENV: ObservableObject {
    @Published var permissionStatus: UNAuthorizationStatus = .notDetermined
    
    private let options: UNAuthorizationOptions
    
    init(options: UNAuthorizationOptions) {
        self.options = options
    }
}


// MARK: - Actions
extension SharedLocalNotificationENV {
    func checkPermissionStatus() {
        SharedLocalNotificationManager.checkForPermissionsWithoutRequest { [weak self] status in
            self?.permissionStatus = status
        }
    }
    
    func requestPermission() {
        Task {
            let granted = await SharedLocalNotificationManager.requestAuthPermission(options: options)
            
            await MainActor.run { [weak self] in
                self?.permissionStatus = granted ? .authorized : .denied
            }
        }
    }
}
