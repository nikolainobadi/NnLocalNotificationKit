//
//  SharedLocalNotificationENV.swift
//
//
//  Created by Nikolai Nobadi on 10/5/24.
//

import Foundation
import UserNotifications

/// An observable object that manages the notification environment.
final class SharedLocalNotificationENV: ObservableObject {
    @Published var permissionStatus: UNAuthorizationStatus = .notDetermined
    private let options: UNAuthorizationOptions

    init(options: UNAuthorizationOptions) {
        self.options = options
    }
}

// MARK: - Actions
extension SharedLocalNotificationENV {
    /// Checks the current notification permission status.
    func checkPermissionStatus() {
        SharedLocalNotificationManager.checkForPermissionsWithoutRequest { [weak self] status in
            self?.permissionStatus = status
        }
    }

    /// Requests notification permission.
    func requestPermission() {
        Task {
            let granted = await SharedLocalNotificationManager.requestAuthPermission(options: options)
            await MainActor.run { [weak self] in
                self?.permissionStatus = granted ? .authorized : .denied
            }
        }
    }
}
