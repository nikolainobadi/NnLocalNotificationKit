//
//  LocalNotificationPermissionRequestViewModifier.swift
//
//
//  Created by Nikolai Nobadi on 10/5/24.
//

import SwiftUI

struct LocalNotificationPermissionRequestViewModifier<DetailView: View>: ViewModifier {
    @StateObject var sharedNotificationENV: SharedLocalNotificationENV
    
    let detailView: (@escaping () -> Void) -> DetailView
    
    func body(content: Content) -> some View {
        if sharedNotificationENV.permissionGranted {
            content
        } else {
            detailView(sharedNotificationENV.requestPermission)
        }
    }
}


// MARK: - Modifier
public extension View {
    func requestionLocalNotificationPermissions<DetailView: View>(options: UNAuthorizationOptions = [.alert, .badge, .sound], @ViewBuilder detailView: @escaping (@escaping () -> Void) -> DetailView) -> some View {
        modifier(LocalNotificationPermissionRequestViewModifier(sharedNotificationENV: .init(options: options), detailView: detailView))
    }
}
