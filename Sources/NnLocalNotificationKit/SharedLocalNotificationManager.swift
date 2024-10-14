//
//  SharedLocalNotificationManager.swift
//
//
//  Created by Nikolai Nobadi on 10/5/24.
//

import UserNotifications

/// Manages all interactions with the local notification system.
public enum SharedLocalNotificationManager {
    private static let notifCenter = UNUserNotificationCenter.current()
}

// MARK: - Permissions
public extension SharedLocalNotificationManager {
    /// Requests authorization for notifications with the specified options.
    /// - Parameter options: The types of notifications to request authorization for.
    /// - Returns: `true` if permission was granted, otherwise `false`.
    @discardableResult
    static func requestAuthPermission(options: UNAuthorizationOptions) async -> Bool {
        return (try? await notifCenter.requestAuthorization(options: options)) ?? false
    }

    /// Checks the current notification permission status without prompting the user.
    /// - Parameter completion: A closure that receives the current authorization status.
    ///   This closure is executed on the main thread.
    static func checkForPermissionsWithoutRequest(completion: @escaping (UNAuthorizationStatus) -> Void) {
        notifCenter.getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }
}

// MARK: - Notifications
public extension SharedLocalNotificationManager {
    /// Schedules a local notification with a time interval trigger.
    /// - Parameter data: The data needed to configure the notification.
    static func scheduleTimeIntervalLocalNotification(data: TimeIntervalLocalNotificationData) async throws {
        let content = makeMutableContent(data)
        let trigger = makeIntervalTrigger(data)
        let request = makeRequest(id: data.id, content: content, trigger: trigger)
        try await notifCenter.add(request)
    }

    /// Cancels specific pending notifications by their identifiers.
    /// - Parameter identifiers: The identifiers of the notifications to cancel.
    static func cancelNotification(identifiers: [String]) {
        notifCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
    }

    /// Cancels all pending notifications.
    static func cancelAllNotifications() {
        notifCenter.removeAllPendingNotificationRequests()
    }

    /// Retrieves all pending notifications.
    /// - Parameter completion: A closure that receives the pending notification requests.
    static func getPendingNotifications(completion: @escaping ([UNNotificationRequest]) -> Void) {
        notifCenter.getPendingNotificationRequests { requests in
            DispatchQueue.main.async {
                completion(requests)
            }
        }
    }

    /// Retrieves all delivered notifications.
    /// - Parameter completion: A closure that receives the delivered notifications.
    static func getDeliveredNotifications(completion: @escaping ([UNNotification]) -> Void) {
        notifCenter.getDeliveredNotifications { notifications in
            DispatchQueue.main.async {
                completion(notifications)
            }
        }
    }

    /// Removes specific delivered notifications by their identifiers.
    /// - Parameter identifiers: The identifiers of the notifications to remove.
    static func removeDeliveredNotifications(identifiers: [String]) {
        notifCenter.removeDeliveredNotifications(withIdentifiers: identifiers)
    }

    /// Removes all delivered notifications.
    static func removeAllDeliveredNotifications() {
        notifCenter.removeAllDeliveredNotifications()
    }

    /// Sets a delegate to handle notification interactions.
    /// - Parameter delegate: The delegate to set.
    static func setNotificationDelegate(_ delegate: UNUserNotificationCenterDelegate) {
        notifCenter.delegate = delegate
    }
}

// MARK: - Private Methods
private extension SharedLocalNotificationManager {
    /// Creates a time interval trigger for a notification.
    static func makeIntervalTrigger(_ data: TimeIntervalLocalNotificationData) -> UNTimeIntervalNotificationTrigger {
        return .init(timeInterval: data.timeInterval, repeats: data.repeats)
    }

    /// Creates a notification request.
    static func makeRequest(id: String, content: UNNotificationContent, trigger: UNNotificationTrigger) -> UNNotificationRequest {
        return .init(identifier: id, content: content, trigger: trigger)
    }

    /// Creates mutable notification content from the provided data.
    static func makeMutableContent(_ data: LocalNotificationData) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = data.title
        content.body = data.body
        content.subtitle = data.subTitle

        if data.withSound {
            content.sound = .default
        }

        return content
    }
}

// MARK: - Dependencies
/// Protocol defining the properties required for local notification data.
public protocol LocalNotificationData {
    var id: String { get }
    var title: String { get }
    var subTitle: String { get }
    var body: String { get }
    var withSound: Bool { get }
}

/// Protocol defining the properties required for time interval-based notifications.
public protocol TimeIntervalLocalNotificationData: LocalNotificationData {
    var timeInterval: TimeInterval { get }
    var repeats: Bool { get }
}
