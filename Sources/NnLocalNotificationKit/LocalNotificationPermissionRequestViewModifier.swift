//
//  LocalNotificationPermissionRequestViewModifier.swift
//
//
//  Created by Nikolai Nobadi on 10/5/24.
//

import SwiftUI

/// A view modifier that handles requesting and displaying notification permissions.
struct LocalNotificationPermissionRequestViewModifier<DetailView: View, DeniedView: View>: ViewModifier {
    @StateObject var sharedNotificationENV: SharedLocalNotificationENV

    let deniedView: (URL?) -> DeniedView
    let detailView: (@escaping () -> Void) -> DetailView

    /// Builds the body of the view modifier based on the notification permission status.
    func body(content: Content) -> some View {
        switch sharedNotificationENV.permissionStatus {
        case .authorized, .provisional:
            content
        case .notDetermined:
            detailView(sharedNotificationENV.requestPermission)
                .onAppear {
                    sharedNotificationENV.checkPermissionStatus()
                }
        default:
            deniedView(URL(string: UIApplication.openSettingsURLString))
        }
    }
}

// MARK: - Modifier
public extension View {
    /// Adds a modifier to handle local notification permissions.
    func requestLocalNotificationPermissions<DetailView: View, DeniedView: View>(options: UNAuthorizationOptions = [.alert, .badge, .sound], @ViewBuilder detailView: @escaping (@escaping () -> Void) -> DetailView, @ViewBuilder deniedView: @escaping (URL?) -> DeniedView) -> some View {
        modifier(LocalNotificationPermissionRequestViewModifier(sharedNotificationENV: .init(options: options), deniedView: deniedView, detailView: detailView))
    }
}
