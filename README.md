
# NnLocalNotificationKit

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org) 
[![Platform](https://img.shields.io/badge/Platform-iOS_15+-blue.svg)](https://developer.apple.com/ios/) 
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) 
[![Version](https://img.shields.io/badge/Version-0.5.0-green.svg)](https://github.com/nikolainobadi/NnLocalNotificationKit/releases)

A lightweight Swift package that simplifies managing local notifications on iOS, including scheduling, retrieving, and handling permissions.

**GitHub Repository:** [NnLocalNotificationKit](https://github.com/nikolainobadi/NnLocalNotificationKit)

## Overview

`NnLocalNotificationKit` provides an easy-to-use API for working with local notifications. It supports:
- Scheduling notifications with time intervals.
- Checking and managing pending and delivered notifications.
- Handling notification permissions and user interactions.
- Integrating notification request views within SwiftUI apps.

---

## Installation

### Swift Package Manager

To install `NnLocalNotificationKit`:

1. Open your project in **Xcode**.
2. Go to **File > Add Packages**.
3. Enter the repository URL:
   ```
   https://github.com/nikolainobadi/NnLocalNotificationKit
   ```
4. Select the **0.5.0** release or choose the `main` branch.
5. Add the package to your project.

---

## Usage

### 1. Requesting Notification Permissions

```swift
import NnLocalNotificationKit

Task {
    let granted = await SharedLocalNotificationManager.requestAuthPermission(options: [.alert, .sound, .badge])
    print("Permission granted: \(granted)")
}
```

### 2. Scheduling a Time Interval Notification

First, conform to the `TimeIntervalLocalNotificationData` protocol:

```swift
struct MyNotification: TimeIntervalLocalNotificationData {
    let id: String
    let title: String
    let subTitle: String
    let body: String
    let withSound: Bool
    let timeInterval: TimeInterval
    let repeats: Bool
}
```

Then, schedule the notification:

```swift
let notification = MyNotification(
    id: "reminder",
    title: "Workout Time",
    subTitle: "Let's get moving!",
    body: "Your workout starts in 10 minutes.",
    withSound: true,
    timeInterval: 600,
    repeats: false
)

Task {
    try await SharedLocalNotificationManager.scheduleTimeIntervalLocalNotification(data: notification)
}
```

### 3. Checking Notification Permissions Without Prompting

```swift
SharedLocalNotificationManager.checkForPermissionsWithoutRequest { status in
    switch status {
    case .authorized:
        print("Notifications are authorized.")
    case .denied:
        print("Notifications are denied.")
    default:
        print("Permission not determined.")
    }
}
```

### 4. Canceling Notifications

```swift
SharedLocalNotificationManager.cancelNotification(identifiers: ["reminder"])
SharedLocalNotificationManager.cancelAllNotifications()
```

### 5. Retrieving Pending and Delivered Notifications

```swift
SharedLocalNotificationManager.getPendingNotifications { requests in
    print("Pending notifications: \(requests.map { $0.identifier })")
}

SharedLocalNotificationManager.getDeliveredNotifications { notifications in
    print("Delivered notifications: \(notifications.map { $0.request.identifier })")
}
```

### 6. SwiftUI Integration – Requesting Permission via View Modifier

```swift
import SwiftUI
import NnLocalNotificationKit

struct ContentView: View {
    var body: some View {
        Text("Request Notifications")
            .requestLocalNotificationPermissions { requestPermission in
                Button("Allow Notifications") {
                    requestPermission()
                }
            } deniedView: { settingsURL in
                if let url = settingsURL {
                    Button("Open Settings") {
                        UIApplication.shared.open(url)
                    }
                } else {
                    Text("Notifications are disabled.")
                }
            }
    }
}
```

---

## Features

- **Permission Handling:** Request and check notification permissions.
- **Scheduling Notifications:** Schedule notifications with time intervals.
- **Retrieve Notifications:** Get pending or delivered notifications.
- **Cancel Notifications:** Remove individual or all notifications.
- **SwiftUI Support:** Use a SwiftUI modifier to manage permissions seamlessly.

---

## Requirements

- **iOS:** 15.0 or later  
- **Swift:** 5.9

---

## Documentation

Inline documentation is provided for all public methods and types. Please explore the code or use Xcode's Quick Help (`⌥ + click`) to learn more about each feature.

---

## Contributing

Contributions are welcome! Please feel free to [open an issue](https://github.com/nikolainobadi/NnLocalNotificationKit/issues/new) if you'd like to help improve this swift package.

---

## License

This project is released under the MIT License. See [LICENSE](LICENSE) for details.
