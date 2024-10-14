//
//  SharedLocalNotificationManager.swift
//
//
//  Created by Nikolai Nobadi on 10/5/24.
//

import UserNotifications

public enum SharedLocalNotificationManager {
    private static let notifCenter = UNUserNotificationCenter.current()
}

// MARK: - Permissions
public extension SharedLocalNotificationManager {
    @discardableResult
    static func requestAuthPermission(options: UNAuthorizationOptions) async -> Bool {
        return (try? await notifCenter.requestAuthorization(options: options)) ?? false
    }

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
    static func scheduleTimeIntervalLocalNotification(data: TimeIntervalLocalNotificationData) async throws {
        let content = makeMutableContent(data)
        let trigger = makeIntervalTrigger(data)
        let request = makeRequest(id: data.id, content: content, trigger: trigger)
        try await notifCenter.add(request)
    }

    static func cancelNotification(identifiers: [String]) {
        notifCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
    }

    static func cancelAllNotifications() {
        notifCenter.removeAllPendingNotificationRequests()
    }

    static func getPendingNotifications(completion: @escaping ([UNNotificationRequest]) -> Void) {
        notifCenter.getPendingNotificationRequests { requests in
            DispatchQueue.main.async {
                completion(requests)
            }
        }
    }

    static func getDeliveredNotifications(completion: @escaping ([UNNotification]) -> Void) {
        notifCenter.getDeliveredNotifications { notifications in
            DispatchQueue.main.async {
                completion(notifications)
            }
        }
    }

    static func removeDeliveredNotifications(identifiers: [String]) {
        notifCenter.removeDeliveredNotifications(withIdentifiers: identifiers)
    }

    static func removeAllDeliveredNotifications() {
        notifCenter.removeAllDeliveredNotifications()
    }

    static func setNotificationDelegate(_ delegate: UNUserNotificationCenterDelegate) {
        notifCenter.delegate = delegate
    }
}


// MARK: - Private Methods
private extension SharedLocalNotificationManager {
    static func makeIntervalTrigger(_ data: TimeIntervalLocalNotificationData) -> UNTimeIntervalNotificationTrigger {
        return .init(timeInterval: data.timeInterval, repeats: data.repeats)
    }

    static func makeRequest(id: String, content: UNNotificationContent, trigger: UNNotificationTrigger) -> UNNotificationRequest {
        return .init(identifier: id, content: content, trigger: trigger)
    }

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
public protocol LocalNotificationData {
    var id: String { get }
    var title: String { get }
    var subTitle: String { get }
    var body: String { get }
    var withSound: Bool { get }
}

public protocol TimeIntervalLocalNotificationData: LocalNotificationData {
    var timeInterval: TimeInterval { get }
    var repeats: Bool { get }
}
